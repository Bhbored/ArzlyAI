import { Link } from "react-router-dom"
import { useQuery } from "@tanstack/react-query"
import {
  Archive,
  ArrowUpRight,
  MessageSquarePlus,
  Package,
  Puzzle,
} from "lucide-react"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Skeleton } from "@/components/ui/skeleton"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { useAuth } from "../../../providers/authContext"
import { sessionQueries } from "../../sessions/sessions.service"
import { presetQueries } from "../../presets/presets.service"
import { capabilityQueries } from "../../capabilities/capabilities.service"
import { DataTableShell } from "../../../shared/components/DataTableShell"
import { PageHeader } from "../../../shared/components/PageHeader"

export default function DashboardPage() {
  const { user } = useAuth()
  const sessionsQuery = useQuery(sessionQueries.list())
  const presetsQuery = useQuery(presetQueries.list())
  const capabilitiesQuery = useQuery(capabilityQueries.list())

  const sessions = sessionsQuery.data ?? []
  const presets = presetsQuery.data ?? []
  const capabilities = (capabilitiesQuery.data ?? []).filter(item => item.kind === "Integration")

  const activeSessions = sessions.filter((s) => s.status === "Active" || s.status === "ReadyToPublish")
  const published = presets.filter((p) => p.status === "Published")
  const archived = presets.filter((p) => p.status === "Archived")
  const recentSessions = [...sessions]
    .sort(
      (a, b) =>
        new Date(b.updatedAtUtc).getTime() - new Date(a.updatedAtUtc).getTime(),
    )
    .slice(0, 8)

  const firstName =
    user?.displayName?.trim().split(/\s+/)[0] || user?.email || "Admin"

  return (
    <div className="space-y-6">
      <PageHeader
        title="Dashboard"
        description="Create workflows, review published versions, and browse integrations."
      />

      <Card className="relative overflow-hidden border-border/80 bg-card">
        <div className="pointer-events-none absolute inset-0 mesh-gradient opacity-60" aria-hidden />
        <CardHeader className="relative">
          <Badge className="w-fit bg-primary/15 text-primary hover:bg-primary/15">
            Admin
          </Badge>
          <CardTitle className="text-3xl">Hey, {firstName}</CardTitle>
          <CardDescription>
            Manage authoring chats and published preset versions.
          </CardDescription>
        </CardHeader>
        <CardContent className="relative flex flex-wrap gap-2">
          <Button asChild className="bg-gradient-primary text-primary-foreground">
            <Link to="/sessions?new=1">
              New chat
              <ArrowUpRight className="size-4" />
            </Link>
          </Button>
          <Button asChild variant="outline">
            <Link to="/presets">Open catalog</Link>
          </Button>
        </CardContent>
      </Card>

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard
          label="Active chats"
          value={activeSessions.length}
          loading={sessionsQuery.isPending}
          icon={MessageSquarePlus}
          to="/sessions"
        />
        <StatCard
          label="Published"
          value={published.length}
          loading={presetsQuery.isPending}
          icon={Package}
          to="/presets"
        />
        <StatCard
          label="Archived"
          value={archived.length}
          loading={presetsQuery.isPending}
          icon={Archive}
          to="/presets"
        />
        <StatCard
          label="Integrations"
          value={capabilities.length}
          loading={capabilitiesQuery.isPending}
          icon={Puzzle}
          to="/integrations"
        />
      </div>

      <DataTableShell title="Recent chats">
        {sessionsQuery.isPending ? (
          <div className="space-y-2 p-4">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : sessionsQuery.isError ? (
          <div className="p-6 text-sm text-destructive">Could not load chats. <Button type="button" variant="outline" size="sm" onClick={() => void sessionsQuery.refetch()}>Retry</Button></div>
        ) : recentSessions.length === 0 ? (
          <p className="p-6 text-sm text-muted-foreground">
            No authoring chats yet. Create one to start drafting a preset.
          </p>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Title</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Revision</TableHead>
                <TableHead>Updated</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {recentSessions.map((session) => (
                <TableRow key={session.id}>
                  <TableCell>
                    <Link
                      to={`/sessions/${session.id}`}
                      className="font-medium text-primary hover:underline"
                    >
                      {session.title?.trim() || "Untitled chat"}
                    </Link>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{session.status}</Badge>
                  </TableCell>
                  <TableCell>{session.revision}</TableCell>
                  <TableCell className="text-muted-foreground">
                    {new Date(session.updatedAtUtc).toLocaleString()}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </DataTableShell>
    </div>
  )
}

function StatCard({
  label,
  value,
  loading,
  icon: Icon,
  to,
}: Readonly<{
  label: string
  value: number
  loading: boolean
  icon: typeof Package
  to: string
}>) {
  return (
    <Link to={to}>
      <Card className="border-border/80 transition-colors hover:border-primary/40">
        <CardHeader className="flex flex-row items-center justify-between pb-2">
          <CardDescription className="uppercase tracking-widest">
            {label}
          </CardDescription>
          <Icon className="size-4 text-primary" aria-hidden />
        </CardHeader>
        <CardContent>
          {loading ? (
            <Skeleton className="h-8 w-16" />
          ) : (
            <p className="text-3xl font-bold tabular-nums">{value}</p>
          )}
        </CardContent>
      </Card>
    </Link>
  )
}
