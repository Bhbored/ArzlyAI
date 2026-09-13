import { useMemo, useState } from "react"
import { Link, useNavigate } from "react-router-dom"
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { toast } from "sonner"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
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
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { MoreHorizontal } from "lucide-react"
import { ApiError } from "../../shared/api/http"
import { PageHeader } from "../../shared/components/PageHeader"
import { DataTableShell } from "../../shared/components/DataTableShell"
import { sessionKeys } from "../sessions/sessions.service"
import {
  archivePresetVersion,
  clonePresetToDraft,
  presetKeys,
  presetQueries,
} from "./presets.service"

export default function PresetsPage() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const presetsQuery = useQuery(presetQueries.list())
  const [statusFilter, setStatusFilter] = useState<string>("all")
  const [archiveTarget, setArchiveTarget] = useState<{
    key: string
    version: number
  } | null>(null)

  const presets = useMemo(() => {
    const list = presetsQuery.data ?? []
    if (statusFilter === "all") return list
    return list.filter((p) => p.status === statusFilter)
  }, [presetsQuery.data, statusFilter])

  const clone = useMutation({
    mutationFn: ({ key, version }: { key: string; version: number }) =>
      clonePresetToDraft(key, version),
    onSuccess: async (session) => {
      await queryClient.invalidateQueries({ queryKey: sessionKeys.all })
      toast.success("Draft session created from version")
      navigate(`/sessions/${session.id}`)
    },
    onError: (error) =>
      toast.error("Could not clone version", {
        description: error instanceof Error ? error.message : undefined,
      }),
  })

  const archive = useMutation({
    mutationFn: ({ key, version }: { key: string; version: number }) =>
      archivePresetVersion(key, version),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: presetKeys.all })
      toast.success("Version archived")
      setArchiveTarget(null)
    },
    onError: (error) =>
      toast.error("Could not archive version", {
        description:
          error instanceof ApiError ? error.message : "Unexpected error",
      }),
  })

  return (
    <div className="space-y-6">
      <PageHeader
        title="Preset catalog"
        description="Published and archived immutable versions. Clone a version to revise it."
      />

      <DataTableShell
        title="Versions"
        toolbar={
          <Select value={statusFilter} onValueChange={setStatusFilter}>
            <SelectTrigger className="w-40">
              <SelectValue placeholder="Status" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All</SelectItem>
              <SelectItem value="Published">Published</SelectItem>
              <SelectItem value="Archived">Archived</SelectItem>
            </SelectContent>
          </Select>
        }
      >
        {presetsQuery.isPending ? (
          <div className="space-y-2 p-4">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : presets.length === 0 ? (
          <p className="p-6 text-sm text-muted-foreground">
            The catalog is empty. That is valid until the first publish.
          </p>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Key</TableHead>
                <TableHead>Name</TableHead>
                <TableHead>Version</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Published</TableHead>
                <TableHead className="w-12" />
              </TableRow>
            </TableHeader>
            <TableBody>
              {presets.map((preset) => (
                <TableRow key={`${preset.key}-${preset.version}`}>
                  <TableCell>
                    <Link
                      to={`/presets/${encodeURIComponent(preset.key)}/${preset.version}`}
                      className="font-medium text-primary hover:underline"
                    >
                      {preset.key}
                    </Link>
                  </TableCell>
                  <TableCell>{preset.name}</TableCell>
                  <TableCell>{preset.version}</TableCell>
                  <TableCell>
                    <Badge variant="outline">{preset.status}</Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {preset.publishedAtUtc
                      ? new Date(preset.publishedAtUtc).toLocaleString()
                      : "—"}
                  </TableCell>
                  <TableCell>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="icon" aria-label="Actions">
                          <MoreHorizontal className="size-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem
                          onClick={() =>
                            navigate(
                              `/presets/${encodeURIComponent(preset.key)}/${preset.version}`,
                            )
                          }
                        >
                          View
                        </DropdownMenuItem>
                        <DropdownMenuItem
                          onClick={() =>
                            clone.mutate({
                              key: preset.key,
                              version: preset.version,
                            })
                          }
                        >
                          Clone to draft
                        </DropdownMenuItem>
                        {preset.status === "Published" ? (
                          <DropdownMenuItem
                            className="text-destructive"
                            onClick={() =>
                              setArchiveTarget({
                                key: preset.key,
                                version: preset.version,
                              })
                            }
                          >
                            Archive
                          </DropdownMenuItem>
                        ) : null}
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </DataTableShell>

      <AlertDialog
        open={archiveTarget !== null}
        onOpenChange={(open) => {
          if (!open) setArchiveTarget(null)
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Archive this version?</AlertDialogTitle>
            <AlertDialogDescription>
              It will leave the public catalog but remain in admin history.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (archiveTarget) archive.mutate(archiveTarget)
              }}
            >
              Archive
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  )
}
