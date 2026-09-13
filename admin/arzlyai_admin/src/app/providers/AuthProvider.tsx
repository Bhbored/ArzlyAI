import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
  type ReactNode,
} from "react"
import { apiFetch, configureHttp } from "../shared/api/http"
import type {
  AdminAuthenticationResponse,
  AdminUser,
  AuthTokens,
} from "../shared/types"

const STORAGE_KEY = "arzlyai.admin.auth"

interface StoredAuth {
  user: AdminUser
  tokens: AuthTokens
}

interface AuthState {
  user: AdminUser | null
  loading: boolean
  getAccessToken: () => string | null
  login: (email: string, password: string) => Promise<{ error?: string }>
  logout: () => Promise<void>
}

const AuthContext = createContext<AuthState | null>(null)

function readStored(): StoredAuth | null {
  try {
    const raw = sessionStorage.getItem(STORAGE_KEY)
    if (!raw) return null
    return JSON.parse(raw) as StoredAuth
  } catch {
    return null
  }
}

function writeStored(value: StoredAuth | null) {
  if (!value) {
    sessionStorage.removeItem(STORAGE_KEY)
    return
  }
  sessionStorage.setItem(STORAGE_KEY, JSON.stringify(value))
}

export function AuthProvider({ children }: { readonly children: ReactNode }) {
  const [user, setUser] = useState<AdminUser | null>(null)
  const [loading, setLoading] = useState(true)
  const tokensRef = useRef<AuthTokens | null>(null)

  const clearSession = useCallback(() => {
    tokensRef.current = null
    writeStored(null)
    setUser(null)
  }, [])

  const applyAuth = useCallback((data: AdminAuthenticationResponse) => {
    const nextUser: AdminUser = {
      adminId: data.adminId,
      email: data.email,
      displayName: data.displayName,
    }
    const tokens: AuthTokens = {
      accessToken: data.accessToken,
      accessTokenExpiresAtUtc: data.accessTokenExpiresAtUtc,
      refreshToken: data.refreshToken,
      refreshTokenExpiresAtUtc: data.refreshTokenExpiresAtUtc,
    }
    tokensRef.current = tokens
    writeStored({ user: nextUser, tokens })
    setUser(nextUser)
  }, [])

  useEffect(() => {
    configureHttp({
      getAccessToken: () => tokensRef.current?.accessToken ?? null,
      getRefreshToken: () => tokensRef.current?.refreshToken ?? null,
      getAccessTokenExpiresAtUtc: () =>
        tokensRef.current?.accessTokenExpiresAtUtc ?? null,
      setTokens: (tokens) => {
        tokensRef.current = tokens
        const stored = readStored()
        if (stored) {
          writeStored({ user: stored.user, tokens })
        }
      },
      clearTokens: () => {
        tokensRef.current = null
        writeStored(null)
      },
      onUnauthorized: () => {
        clearSession()
      },
    })
  }, [clearSession])

  useEffect(() => {
    const stored = readStored()
    if (!stored) {
      setLoading(false)
      return
    }

    tokensRef.current = stored.tokens

    apiFetch<AdminAuthenticationResponse>(
      "/api/v1/admin/auth/refresh",
      {
        method: "POST",
        body: JSON.stringify({
          accessToken: stored.tokens.accessToken,
          refreshToken: stored.tokens.refreshToken,
        }),
      },
      { auth: false, retry: false },
    )
      .then((data) => {
        applyAuth(data)
      })
      .catch(() => {
        clearSession()
      })
      .finally(() => setLoading(false))
  }, [applyAuth, clearSession])

  const login = useCallback(
    async (email: string, password: string) => {
      try {
        const data = await apiFetch<AdminAuthenticationResponse>(
          "/api/v1/admin/auth/login",
          {
            method: "POST",
            body: JSON.stringify({ email, password }),
          },
          { auth: false, retry: false },
        )
        applyAuth(data)
        return {}
      } catch (error) {
        const message =
          error instanceof Error ? error.message : "Unable to sign in"
        return { error: message }
      }
    },
    [applyAuth],
  )

  const logout = useCallback(async () => {
    try {
      await apiFetch<void>("/api/v1/admin/auth/logout", { method: "POST" })
    } catch {
      // Ignore logout network errors; always clear local session.
    } finally {
      clearSession()
    }
  }, [clearSession])

  const getAccessToken = useCallback(
    () => tokensRef.current?.accessToken ?? null,
    [],
  )

  const value = useMemo(
    () => ({ user, loading, getAccessToken, login, logout }),
    [user, loading, getAccessToken, login, logout],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth(): AuthState {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error("useAuth must be used within AuthProvider")
  return ctx
}
