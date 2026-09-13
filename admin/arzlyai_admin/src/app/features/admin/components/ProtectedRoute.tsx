import { Navigate, useLocation } from "react-router-dom"
import { Loader2 } from "lucide-react"
import type { ReactNode } from "react"
import { useAuth } from "../../../providers/AuthProvider"

export default function ProtectedRoute({
  children,
}: {
  readonly children: ReactNode
}) {
  const { user, loading } = useAuth()
  const location = useLocation()

  if (loading) {
    return (
      <div className="flex min-h-dvh items-center justify-center bg-background">
        <Loader2
          className="size-8 animate-spin text-primary"
          aria-label="Loading"
        />
      </div>
    )
  }

  if (!user) {
    return <Navigate to="/login" replace state={{ from: location }} />
  }

  return children
}
