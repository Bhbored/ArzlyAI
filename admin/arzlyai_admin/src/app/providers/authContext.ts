import { createContext, useContext } from "react"
import type { AdminUser } from "../shared/types"

export interface AuthState {
  user: AdminUser | null
  loading: boolean
  getAccessToken: () => string | null
  login: (email: string, password: string) => Promise<{ error?: string }>
  logout: () => Promise<void>
}

export const AuthContext = createContext<AuthState | null>(null)

export function useAuth(): AuthState {
  const context = useContext(AuthContext)
  if (!context) throw new Error("useAuth must be used within AuthProvider")
  return context
}
