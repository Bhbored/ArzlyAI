import { useState, type ReactNode } from "react"
import { Link, useNavigate, useParams } from "react-router-dom"
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { ArrowLeft, Loader2 } from "lucide-react"
import { toast } from "sonner"
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
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog"
import { PageHeader } from "../../shared/components/PageHeader"
import { sessionKeys } from "../sessions/sessions.service"
import {
  archivePresetVersion,
  clonePresetToDraft,
  presetKeys,
  presetQueries,
} from "./presets.service"
export default function PresetDetailPage() {
  const { key = "", version: versionParam = "0" } = useParams()
  const version = Number(versionParam)
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [archiveOpen, setArchiveOpen] = useState(false)

  const detailQuery = useQuery({
    ...presetQueries.detail(key, version),
    enabled: Boolean(key) && Number.isFinite(version) && version > 0,
  })

  const clone = useMutation({
    mutationFn: () => clonePresetToDraft(key, version),
    onSuccess: async (session) => {
      await queryClient.invalidateQueries({ queryKey: sessionKeys.all })
      toast.success("Draft session created")
      navigate(`/sessions/${session.id}`)
    },
    onError: (error) =>
      toast.error("Could not clone version", {
        description: error instanceof Error ? error.message : undefined,
      }),
  })

  const archive = useMutation({
    mutationFn: () => archivePresetVersion(key, version),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: presetKeys.all })
      toast.success("Version archived")
      setArchiveOpen(false)
      navigate("/presets")
    },
    onError: (error) =>
      toast.error("Could not archive version", {
        description: error instanceof Error ? error.message : undefined,
      }),
  })

  if (detailQuery.isPending) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-10 w-64" />
        <Skeleton className="h-40 w-full" />
        <Skeleton className="h-40 w-full" />
      </div>
    )
  }

  if (detailQuery.isError || !detailQuery.data) {
    return (
      <div className="space-y-4">
        <Button asChild variant="ghost">
          <Link to="/presets">
            <ArrowLeft className="size-4" />
            Back
          </Link>
        </Button>
        <p className="text-destructive">Preset version not found.</p>
      </div>
    )
  }

  const { preset, status, adminNotes, publishedByAdminId, supersedesPresetId } =
    detailQuery.data

  return (
    <div className="space-y-6">
      <PageHeader
        title={`${preset.name} · v${preset.version}`}
        description={preset.key}
        actions={
          <div className="flex flex-wrap gap-2">
            <Button asChild variant="outline">
              <Link to="/presets">
                <ArrowLeft className="size-4" />
                Catalog
              </Link>
            </Button>
            <Button
              onClick={() => clone.mutate()}
              disabled={clone.isPending}
              className="bg-gradient-primary text-primary-foreground"
            >
              {clone.isPending ? (
                <Loader2 className="size-4 animate-spin" />
              ) : null}
              Clone to draft
            </Button>
            {status === "Published" ? (
              <AlertDialog open={archiveOpen} onOpenChange={setArchiveOpen}>
                <AlertDialogTrigger asChild>
                  <Button variant="destructive">Archive</Button>
                </AlertDialogTrigger>
                <AlertDialogContent>
                  <AlertDialogHeader>
                    <AlertDialogTitle>Archive this version?</AlertDialogTitle>
                    <AlertDialogDescription>
                      Removes it from public visibility without deleting history.
                    </AlertDialogDescription>
                  </AlertDialogHeader>
                  <AlertDialogFooter>
                    <AlertDialogCancel>Cancel</AlertDialogCancel>
                    <AlertDialogAction
                      className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                      onClick={() => archive.mutate()}
                    >
                      Archive
                    </AlertDialogAction>
                  </AlertDialogFooter>
                </AlertDialogContent>
              </AlertDialog>
            ) : null}
          </div>
        }
      />

      <div className="grid gap-4 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Metadata</CardTitle>
            <CardDescription>Public catalog fields</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3 text-sm">
            <Row label="Status" value={<Badge variant="outline">{status}</Badge>} />
            <Row label="Subtitle" value={preset.subtitle || "—"} />
            <Row label="Description" value={preset.description || "—"} />
            <Row
              label="Detailed"
              value={preset.detailedDescription || "—"}
            />
            <Row
              label="Published by"
              value={publishedByAdminId ?? "—"}
            />
            <Row
              label="Supersedes"
              value={supersedesPresetId ?? "—"}
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Graph summary</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3 text-sm">
            <Row label="Agents" value={String(preset.agents?.length ?? 0)} />
            <Row
              label="Integrations"
              value={String(preset.integrations?.length ?? 0)}
            />
            <Row
              label="Nodes"
              value={String(
                Array.isArray(preset.workflow?.nodes)
                  ? preset.workflow.nodes.length
                  : 0,
              )}
            />
            <Row
              label="Background"
              value={
                preset.backgroundExecution?.mode != null
                  ? String(preset.backgroundExecution.mode)
                  : "—"
              }
            />
          </CardContent>
        </Card>

        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle>Input schema</CardTitle>
          </CardHeader>
          <CardContent>
            <pre className="overflow-x-auto rounded-md border border-border bg-muted/40 p-3 text-xs text-muted-foreground">
              {preset.inputSchemaJson || "—"}
            </pre>
          </CardContent>
        </Card>

        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle>Admin notes</CardTitle>
            <CardDescription>Never exposed on public preset routes</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            {adminNotes.length === 0 ? (
              <p className="text-sm text-muted-foreground">No admin notes.</p>
            ) : (
              adminNotes.map((note, index) => (
                <div
                  key={`${note.title}-${index}`}
                  className="rounded-md border border-border p-3"
                >
                  <div className="mb-1 flex items-center gap-2">
                    <p className="font-medium">{note.title}</p>
                    <Badge variant="outline">{note.severity}</Badge>
                  </div>
                  <p className="text-sm text-muted-foreground">
                    {note.description}
                  </p>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

function Row({
  label,
  value,
}: Readonly<{ label: string; value: ReactNode }>) {
  return (
    <div className="grid gap-1 sm:grid-cols-[8rem_1fr] sm:gap-3">
      <span className="text-xs uppercase tracking-widest text-muted-foreground">
        {label}
      </span>
      <div className="min-w-0 break-words">{value}</div>
    </div>
  )
}
