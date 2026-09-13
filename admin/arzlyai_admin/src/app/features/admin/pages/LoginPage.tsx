import { useState, type SyntheticEvent } from "react"
import { Navigate, useNavigate } from "react-router-dom"
import { Loader2, Lock, Shield } from "lucide-react"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { useAuth } from "../../../providers/AuthProvider"

export default function LoginPage() {
  const { user, loading, login } = useAuth()
  const navigate = useNavigate()
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  if (user) {
    return <Navigate to="/" replace />
  }

  const handleSubmit = async (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    const result = await login(email.trim(), password)
    setSubmitting(false)
    if (result.error) {
      setError(result.error)
      setPassword("")
    } else {
      navigate("/", { replace: true })
    }
  }

  return (
    <div className="relative flex min-h-dvh items-center justify-center overflow-hidden bg-background p-4 mesh-gradient">
      <div
        className="pointer-events-none absolute inset-0 grid-pattern opacity-40"
        aria-hidden
      />

      <Card className="relative z-10 w-full max-w-md border-border/80 bg-card/90 shadow-glow-primary backdrop-blur-md">
        <CardHeader className="items-center text-center">
          <div className="mb-2 flex size-16 items-center justify-center rounded-full border border-primary/30 bg-primary/10 shadow-glow-primary">
            <Shield className="size-8 text-primary" aria-hidden />
          </div>
          <CardTitle className="text-2xl">Admin Access</CardTitle>
          <CardDescription className="uppercase tracking-widest">
            Sign in with your credentials
          </CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <Loader2
                className="size-7 animate-spin text-primary"
                aria-label="Loading"
              />
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-6" noValidate>
              <div className="space-y-2">
                <Label htmlFor="admin-email">Email</Label>
                <Input
                  id="admin-email"
                  type="email"
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value)
                    setError(null)
                  }}
                  placeholder="you@example.com"
                  autoComplete="email"
                  autoFocus
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="admin-password">Password</Label>
                <div className="relative">
                  <Input
                    id="admin-password"
                    type="password"
                    value={password}
                    onChange={(e) => {
                      setPassword(e.target.value)
                      setError(null)
                    }}
                    placeholder="Enter password"
                    autoComplete="current-password"
                    required
                    className="pr-10"
                  />
                  <Lock
                    className="pointer-events-none absolute top-1/2 right-3 size-4 -translate-y-1/2 text-muted-foreground"
                    aria-hidden
                  />
                </div>
              </div>

              <Button
                type="submit"
                className="w-full bg-gradient-primary font-bold uppercase tracking-tight text-primary-foreground"
                disabled={submitting || !email.trim() || !password}
              >
                {submitting ? (
                  <>
                    <Loader2 className="size-4 animate-spin" aria-hidden />
                    Signing in…
                  </>
                ) : (
                  "Sign In"
                )}
              </Button>

              {error ? (
                <p
                  className="rounded-md border border-destructive/30 bg-destructive/10 px-3 py-2 text-center text-sm text-destructive"
                  role="alert"
                >
                  {error}
                </p>
              ) : null}
            </form>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
