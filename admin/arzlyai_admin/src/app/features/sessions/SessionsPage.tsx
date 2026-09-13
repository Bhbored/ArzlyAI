import { useState } from "react"
import { Link, useNavigate } from "react-router-dom"
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { Loader2, Plus, Trash2 } from "lucide-react"
import { toast } from "sonner"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet"
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Skeleton } from "@/components/ui/skeleton"
import { ApiError } from "../../shared/api/http"
import { PageHeader } from "../../shared/components/PageHeader"
import { DataTableShell } from "../../shared/components/DataTableShell"
import {
  abandonSession,
  createSession,
  sessionKeys,
  sessionQueries,
} from "./sessions.service"

export default function SessionsPage() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const sessionsQuery = useQuery(sessionQueries.list())
  const [panelOpen, setPanelOpen] = useState(false)
  const [title, setTitle] = useState("")
  const [abandonId, setAbandonId] = useState<string | null>(null)

  const create = useMutation({
    mutationFn: () => createSession(title),
    onSuccess: async (session) => {
      await queryClient.invalidateQueries({ queryKey: sessionKeys.all })
      toast.success("Session created")
      setPanelOpen(false)
      setTitle("")
      navigate(`/sessions/${session.id}`)
    },
    onError: (error) =>
      toast.error("Could not create session", {
        description: error instanceof Error ? error.message : undefined,
      }),
  })

  const abandon = useMutation({
    mutationFn: (id: string) => abandonSession(id),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: sessionKeys.all })
      toast.success("Session abandoned")
      setAbandonId(null)
    },
    onError: (error) =>
      toast.error("Could not abandon session", {
        description:
          error instanceof ApiError ? error.message : "Unexpected error",
      }),
  })

  const sessions = sessionsQuery.data ?? []

  return (
    <div className="space-y-6">
      <PageHeader
        title="Authoring sessions"
        description="Chat with the authoring agent to draft presets, then validate and publish."
        actions={
          <Button
            onClick={() => setPanelOpen(true)}
            className="bg-gradient-primary text-primary-foreground"
          >
            <Plus className="size-4" />
            New session
          </Button>
        }
      />

      <DataTableShell title="Sessions">
        {sessionsQuery.isPending ? (
          <div className="space-y-2 p-4">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : sessions.length === 0 ? (
          <p className="p-6 text-sm text-muted-foreground">
            No sessions yet. Create one to start drafting.
          </p>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Title</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Assistant</TableHead>
                <TableHead>Revision</TableHead>
                <TableHead>Updated</TableHead>
                <TableHead className="w-24" />
              </TableRow>
            </TableHeader>
            <TableBody>
              {sessions.map((session) => (
                <TableRow key={session.id}>
                  <TableCell>
                    <Link
                      to={`/sessions/${session.id}`}
                      className="font-medium text-primary hover:underline"
                    >
                      {session.title?.trim() || "Untitled session"}
                    </Link>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{session.status}</Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {session.assistantModel
                      ? `${session.assistantModel.provider}/${session.assistantModel.model}`
                      : "—"}
                  </TableCell>
                  <TableCell>{session.revision}</TableCell>
                  <TableCell className="text-muted-foreground">
                    {new Date(session.updatedAtUtc).toLocaleString()}
                  </TableCell>
                  <TableCell>
                    {session.status !== "Abandoned" &&
                    session.status !== "Published" ? (
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon"
                        className="text-destructive"
                        onClick={() => setAbandonId(session.id)}
                        aria-label="Abandon session"
                      >
                        <Trash2 className="size-4" />
                      </Button>
                    ) : null}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </DataTableShell>

      <Sheet open={panelOpen} onOpenChange={setPanelOpen}>
        <SheetContent>
          <SheetHeader>
            <SheetTitle>New authoring session</SheetTitle>
            <SheetDescription>
              Optional title helps you find the draft later.
            </SheetDescription>
          </SheetHeader>
          <div className="space-y-4 px-4">
            <div className="space-y-2">
              <Label htmlFor="session-title">Title</Label>
              <Input
                id="session-title"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="Brain dump to action"
              />
            </div>
          </div>
          <SheetFooter>
            <Button
              variant="outline"
              onClick={() => setPanelOpen(false)}
              disabled={create.isPending}
            >
              Cancel
            </Button>
            <Button
              onClick={() => create.mutate()}
              disabled={create.isPending}
              className="bg-gradient-primary text-primary-foreground"
            >
              {create.isPending ? (
                <Loader2 className="size-4 animate-spin" />
              ) : null}
              Create
            </Button>
          </SheetFooter>
        </SheetContent>
      </Sheet>

      <AlertDialog
        open={abandonId !== null}
        onOpenChange={(open) => {
          if (!open) setAbandonId(null)
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Abandon this session?</AlertDialogTitle>
            <AlertDialogDescription>
              The draft will be marked abandoned and can no longer be edited or
              published.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (abandonId) abandon.mutate(abandonId)
              }}
            >
              Abandon
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  )
}
