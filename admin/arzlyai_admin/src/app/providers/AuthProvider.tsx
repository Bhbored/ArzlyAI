import {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
  type ReactNode,
} from "react"
import { apiFetch, configureHttp } from "../shared/api/http"
import { useQueryClient } from "@tanstack/react-query"
import { AuthContext } from "./authContext"
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
  const queryClient = useQueryClient()
  const [user, setUser] = useState<AdminUser | null>(null)
  const [loading, setLoading] = useState(() => readStored() !== null)
  const tokensRef = useRef<AuthTokens | null>(null)
  const bootstrappedRef = useRef(false)

  const clearSession = useCallback(() => {
    tokensRef.current = null
    writeStored(null)
    setUser(null)
    void queryClient.cancelQueries()
    queryClient.clear()
  }, [queryClient])

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
        if (!tokensRef.current) return
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
    if (bootstrappedRef.current) return
    bootstrappedRef.current = true

    const stored = readStored()
    if (!stored) return

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
