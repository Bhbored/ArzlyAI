import { NavLink } from "react-router-dom"
import {
  LayoutDashboard,
  MessageSquarePlus,
  Package,
  Puzzle,
  KeyRound,
  LogOut,
} from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { useAuth } from "../../../providers/authContext"

const navItems: {
  to: string
  label: string
  icon: typeof LayoutDashboard
  end?: boolean
}[] = [
  { to: "/", label: "Dashboard", icon: LayoutDashboard, end: true },
  { to: "/sessions", label: "Chats", icon: MessageSquarePlus },
  { to: "/presets", label: "Catalog", icon: Package },
  { to: "/integrations", label: "Integrations", icon: Puzzle },
  { to: "/account", label: "Password", icon: KeyRound },
]

interface AdminNavMenuProps {
  readonly onNavigate?: () => void
}

export default function AdminNavMenu({ onNavigate }: AdminNavMenuProps) {
  const { logout } = useAuth()

  return (
    <nav className="flex h-full flex-col" aria-label="Admin">
      <ul className="flex flex-1 flex-col gap-1 overflow-y-auto px-3 py-4">
        {navItems.map(({ to, label, icon: Icon, end }) => (
          <li key={to}>
            <NavLink
              to={to}
              end={end}
              onClick={onNavigate}
              className={({ isActive }) =>
                cn(
                  "flex items-center gap-3 rounded-md px-3 py-3 text-sm tracking-wide transition-all focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary",
                  isActive
                    ? "bg-primary/15 text-primary shadow-glow-primary"
                    : "text-muted-foreground hover:translate-x-0.5 hover:text-foreground",
                )
              }
            >
              <Icon className="size-5 shrink-0" aria-hidden />
              {label}
            </NavLink>
            <Separator className="mt-1 bg-border/40" />
          </li>
        ))}
      </ul>
      <div className="border-t border-border p-3">
        <Button
          type="button"
          variant="ghost"
          className="w-full justify-start gap-3 text-destructive hover:bg-destructive/10 hover:text-destructive"
          onClick={() => {
            void logout()
            onNavigate?.()
          }}
        >
          <LogOut className="size-5" />
          Logout
        </Button>
      </div>
    </nav>
  )
}
