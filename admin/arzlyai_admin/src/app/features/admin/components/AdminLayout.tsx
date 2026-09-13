import { useEffect, useState } from "react"
import { Link, Outlet, useLocation } from "react-router-dom"
import { LogOut, Menu, Shield } from "lucide-react"
import { Button } from "@/components/ui/button"
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet"
import AdminNavMenu from "./AdminNavMenu"
import { useAuth } from "../../../providers/AuthProvider"

const titles: Record<string, string> = {
  "/": "Dashboard",
  "/sessions": "Authoring",
  "/presets": "Catalog",
  "/capabilities": "Capabilities",
  "/account": "Password",
}

function resolveTitle(pathname: string) {
  if (titles[pathname]) return titles[pathname]
  if (pathname.startsWith("/sessions/")) return "Session"
  if (pathname.startsWith("/presets/")) return "Preset Version"
  return "Admin"
}

export default function AdminLayout() {
  const location = useLocation()
  const { logout } = useAuth()
  const [drawerOpen, setDrawerOpen] = useState(false)
  const title = resolveTitle(location.pathname)

  useEffect(() => {
    const previousTitle = document.title
    document.title = `${title} | ArzlyAI Admin`
    let robots = document.querySelector('meta[name="robots"]')
    if (!robots) {
      robots = document.createElement("meta")
      robots.setAttribute("name", "robots")
      document.head.appendChild(robots)
    }
    const previousRobots = robots.getAttribute("content")
    robots.setAttribute("content", "noindex, nofollow")
    return () => {
      document.title = previousTitle
      if (previousRobots) robots.setAttribute("content", previousRobots)
      else robots.setAttribute("content", "index, follow")
    }
  }, [title])

  return (
    <div className="flex min-h-dvh bg-background text-foreground">
      <aside className="fixed inset-y-0 left-0 z-40 hidden w-64 border-r border-border bg-sidebar md:flex md:flex-col">
        <div className="border-b border-border px-6 py-6">
          <Link
            to="/"
            className="flex items-center gap-2 text-xl font-bold text-primary"
          >
            <Shield className="size-6" aria-hidden />
            ArzlyAI
          </Link>
        </div>
        <AdminNavMenu />
      </aside>

      <Sheet open={drawerOpen} onOpenChange={setDrawerOpen}>
        <SheetContent
          side="left"
          className="w-64 border-border bg-sidebar p-0"
        >
          <SheetHeader className="border-b border-border px-6 py-6 text-left">
            <SheetTitle className="flex items-center gap-2 text-primary">
              <Shield className="size-6" aria-hidden />
              ArzlyAI
            </SheetTitle>
          </SheetHeader>
          <AdminNavMenu onNavigate={() => setDrawerOpen(false)} />
        </SheetContent>
      </Sheet>

      <div className="flex min-h-dvh flex-1 flex-col md:ml-64">
        <header className="sticky top-0 z-30 flex items-center justify-between gap-4 border-b border-border bg-sidebar/95 px-4 py-4 backdrop-blur md:px-8 md:py-6">
          <div className="flex items-center gap-3">
            <Button
              type="button"
              variant="ghost"
              size="icon"
              className="text-primary md:hidden"
              onClick={() => setDrawerOpen(true)}
              aria-label="Open menu"
            >
              <Menu className="size-6" />
            </Button>
            <h1 className="text-xl font-bold text-foreground md:text-2xl">
              {title}
            </h1>
          </div>
          <Button
            type="button"
            variant="outline"
            className="gap-2 border-destructive/30 text-destructive hover:bg-destructive/10"
            onClick={() => void logout()}
          >
            <LogOut className="size-4" />
            Logout
          </Button>
        </header>
        <main className="flex-1 overflow-y-auto p-4 md:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
