import type { AuthTokens } from "../types"

export const STALE_TIME = 5 * 60 * 1000

const API_BASE = (import.meta.env.VITE_API_BASE_URL ?? "").replace(/\/$/, "")

export class ApiError extends Error {
  readonly status: number
  readonly correlationId?: string
  readonly validation?: { path: string; message: string }[]

  constructor(
    message: string,
    status: number,
    options?: {
      correlationId?: string
      validation?: { path: string; message: string }[]
    },
  ) {
    super(message)
    this.name = "ApiError"
    this.status = status
    this.correlationId = options?.correlationId
    this.validation = options?.validation
  }
}

type TokenAccessor = {
  getAccessToken: () => string | null
  getRefreshToken: () => string | null
  getAccessTokenExpiresAtUtc: () => string | null
  setTokens: (tokens: AuthTokens) => void
  clearTokens: () => void
  onUnauthorized: () => void
}


let tokenAccessor: TokenAccessor | null = null
let refreshPromise: Promise<boolean> | null = null

export function configureHttp(accessor: TokenAccessor) {
  tokenAccessor = accessor
}

export function apiUrl(path: string) {
  const normalized = path.startsWith("/") ? path : `/${path}`
  return `${API_BASE}${normalized}`
}

async function parseError(response: Response): Promise<ApiError> {
  try {
    const body = (await response.json()) as {
      message?: string
      correlationId?: string
      validation?: { errors?: { path: string; message: string }[] }
    }
    return new ApiError(body.message ?? response.statusText, response.status, {
      correlationId: body.correlationId,
      validation: body.validation?.errors,
    })
  } catch {
    return new ApiError(response.statusText || "Request failed", response.status)
  }
}

async function tryRefresh(): Promise<boolean> {
  if (!tokenAccessor) return false
  const accessToken = tokenAccessor.getAccessToken()
  const refreshToken = tokenAccessor.getRefreshToken()
  if (!accessToken || !refreshToken) return false

  if (!refreshPromise) {
    refreshPromise = (async () => {
      try {
        const response = await fetch(apiUrl("/api/v1/admin/auth/refresh"), {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ accessToken, refreshToken }),
        })
        if (!response.ok) {
          tokenAccessor?.clearTokens()
          tokenAccessor?.onUnauthorized()
          return false
        }
        const data = (await response.json()) as AuthTokens & {
          adminId: string
          email: string
          displayName: string
        }
        tokenAccessor?.setTokens({
          accessToken: data.accessToken,
          accessTokenExpiresAtUtc: data.accessTokenExpiresAtUtc,
          refreshToken: data.refreshToken,
          refreshTokenExpiresAtUtc: data.refreshTokenExpiresAtUtc,
        })
        return true
      } catch {
        tokenAccessor?.clearTokens()
        tokenAccessor?.onUnauthorized()
        return false
      } finally {
        refreshPromise = null
      }
    })()
  }

  return refreshPromise
}

/** Returns a usable access token, refreshing first when expiry is near. */
export async function ensureFreshAccessToken(
  skewMs = 120_000,
): Promise<string | null> {
  if (!tokenAccessor) return null
  const token = tokenAccessor.getAccessToken()
  if (!token) return null

  const expiresAt = tokenAccessor.getAccessTokenExpiresAtUtc()
  if (expiresAt) {
    const expiresMs = Date.parse(expiresAt)
    if (!Number.isNaN(expiresMs) && expiresMs - Date.now() <= skewMs) {
      const refreshed = await tryRefresh()
      if (!refreshed) return null
      return tokenAccessor.getAccessToken()
    }
  }

  return token
}

export async function apiFetch<T>(
  path: string,
  init: RequestInit = {},
  options?: { auth?: boolean; retry?: boolean },
): Promise<T> {
  const auth = options?.auth ?? true
  const retry = options?.retry ?? true
  const headers = new Headers(init.headers)

  if (init.body && !headers.has("Content-Type")) {
    headers.set("Content-Type", "application/json")
  }

  if (auth) {
    const token = await ensureFreshAccessToken()
    if (token) headers.set("Authorization", `Bearer ${token}`)
  }

  const response = await fetch(apiUrl(path), { ...init, headers })

  if (response.status === 401 && auth && retry) {
    const refreshed = await tryRefresh()
    if (refreshed) {
      return apiFetch<T>(path, init, { auth, retry: false })
    }
    tokenAccessor?.onUnauthorized()
    throw await parseError(response)
  }

  if (response.status === 204) {
    return undefined as T
  }

  if (!response.ok) {
    throw await parseError(response)
  }

  if (response.status === 201 || response.headers.get("content-type")?.includes("application/json")) {
    return (await response.json()) as T
  }

  const text = await response.text()
  return (text ? JSON.parse(text) : undefined) as T
}
