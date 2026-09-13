import { useMemo, useState, type ReactNode, type SyntheticEvent } from "react"
import { Link, useParams } from "react-router-dom"
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import {
  ArrowLeft,
  Loader2,
  Send,
  ShieldAlert,
  Wrench,
} from "lucide-react"
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
import { ScrollArea } from "@/components/ui/scroll-area"
import { Separator } from "@/components/ui/separator"
import { Skeleton } from "@/components/ui/skeleton"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Textarea } from "@/components/ui/textarea"
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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { cn } from "@/lib/utils"
import { ApiError } from "../../shared/api/http"
import type { AuthoringSession, ValidationIssue } from "../../shared/types"
import { isValidationValid } from "../../shared/types"
import { capabilityQueries } from "../capabilities/capabilities.service"
import { presetKeys } from "../presets/presets.service"
import {
  publishSession,
  sendMessage,
  sessionKeys,
  sessionQueries,
  setAssistantModel,
  validateSession,
} from "./sessions.service"
import { useAuthoringHub } from "./useAuthoringHub"

function modelValue(provider: string, model: string) {
  return `${provider}::${model}`
}

function parseModelValue(value: string) {
  const sep = value.indexOf("::")
  if (sep < 0) return null
  return {
    provider: value.slice(0, sep),
    model: value.slice(sep + 2),
  }
}

export default function SessionWorkspacePage() {
  const { id = "" } = useParams()
  const queryClient = useQueryClient()
  const [composer, setComposer] = useState("")
  const [turnActive, setTurnActive] = useState(false)
  const [activeTools, setActiveTools] = useState<string[]>([])
  const [deltaText, setDeltaText] = useState<string | null>(null)
  const [publishOpen, setPublishOpen] = useState(false)

  const sessionQuery = useQuery({
    ...sessionQueries.detail(id),
    enabled: Boolean(id),
  })
  const modelsQuery = useQuery(sessionQueries.models())
  const capabilitiesQuery = useQuery(capabilityQueries.list())

  const session = sessionQuery.data
  const models = modelsQuery.data ?? []
  const capabilityKeys = useMemo(
    () => new Set((capabilitiesQuery.data ?? []).map((c) => c.key)),
    [capabilitiesQuery.data],
  )

  const missingCapabilities = useMemo(() => {
    const draft = session?.draft
    if (!draft) return [] as string[]
    const refs = new Set<string>()
    for (const node of draft.workflow?.nodes ?? []) {
      if (node.referenceKey) refs.add(node.referenceKey)
    }
    return [...refs].filter((key) => !capabilityKeys.has(key))
  }, [session?.draft, capabilityKeys])

  const { connectionState } = useAuthoringHub(id || undefined, {
    onTurnStarted: () => {
      setTurnActive(true)
      setActiveTools([])
      setDeltaText(null)
    },
    onContentDelta: (content) => setDeltaText(content),
    onToolStarted: (name) =>
      setActiveTools((prev) => (prev.includes(name) ? prev : [...prev, name])),
    onToolCompleted: (name) =>
      setActiveTools((prev) => prev.filter((item) => item !== name)),
    onDraftUpdated: () => {
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
    },
    onValidationChanged: () => {
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
    },
    onTurnCompleted: (result) => {
      setTurnActive(false)
      setActiveTools([])
      setDeltaText(null)
      queryClient.setQueryData(sessionKeys.detail(id), result.session)
      void queryClient.invalidateQueries({ queryKey: sessionKeys.list() })
    },
    onTurnFailed: (message) => {
      setTurnActive(false)
      setActiveTools([])
      setDeltaText(null)
      toast.error("Authoring turn failed", { description: message })
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
    },
  })

  const changeModel = useMutation({
    mutationFn: (value: string) => {
      if (!session) throw new Error("Session not loaded")
      const parsed = parseModelValue(value)
      if (!parsed) throw new Error("Invalid model selection")
      return setAssistantModel(
        session.id,
        parsed.provider,
        parsed.model,
        session.revision,
      )
    },
    onSuccess: (next) => {
      queryClient.setQueryData(sessionKeys.detail(id), next)
      void queryClient.invalidateQueries({ queryKey: sessionKeys.list() })
      toast.success("Assistant model updated")
    },
    onError: (error) => {
      if (error instanceof ApiError && error.status === 409) {
        toast.error("Stale revision", {
          description: "Reloading the session.",
        })
        void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
        return
      }
      toast.error("Could not change assistant model", {
        description: error instanceof Error ? error.message : undefined,
      })
    },
  })

  const send = useMutation({
    mutationFn: () => {
      if (!session) throw new Error("Session not loaded")
      return sendMessage(session.id, composer.trim(), session.revision)
    },
    onMutate: () => {
      setTurnActive(true)
    },
    onSuccess: (result) => {
      setComposer("")
      setTurnActive(false)
      setDeltaText(null)
      queryClient.setQueryData(sessionKeys.detail(id), result.session)
      void queryClient.invalidateQueries({ queryKey: sessionKeys.list() })
    },
    onError: (error) => {
      setTurnActive(false)
      if (error instanceof ApiError && error.status === 409) {
        toast.error("Stale revision", {
          description: "Reloading the session.",
        })
        void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
        return
      }
      toast.error("Could not send message", {
        description: error instanceof Error ? error.message : undefined,
      })
    },
  })

  const validate = useMutation({
    mutationFn: () => validateSession(id),
    onSuccess: (next) => {
      queryClient.setQueryData(sessionKeys.detail(id), next)
      toast.success(
        isValidationValid(next.validation)
          ? "Draft is valid"
          : "Validation found issues",
      )
    },
    onError: (error) => {
      if (error instanceof ApiError && error.status === 409) {
        void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
      }
      toast.error("Validation failed", {
        description: error instanceof Error ? error.message : undefined,
      })
    },
  })

  const publish = useMutation({
    mutationFn: () => {
      if (!session) throw new Error("Session not loaded")
      return publishSession(session.id, session.revision)
    },
    onSuccess: async (result) => {
      toast.success("Preset published", {
        description: `Preset id ${result.presetId}`,
      })
      setPublishOpen(false)
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: sessionKeys.all }),
        queryClient.invalidateQueries({ queryKey: presetKeys.all }),
      ])
    },
    onError: (error) => {
      if (error instanceof ApiError && error.status === 422) {
        toast.error("Publish blocked by validation", {
          description: error.validation
            ?.map((issue) => `${issue.path}: ${issue.message}`)
            .join(" · "),
        })
        void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
        return
      }
      if (error instanceof ApiError && error.status === 409) {
        toast.error("Stale revision", { description: "Reloading the session." })
        void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) })
        return
      }
      toast.error("Could not publish", {
        description: error instanceof Error ? error.message : undefined,
      })
    },
  })

  const canEdit =
    session?.status === "Active" || session?.status === "ReadyToPublish"
  const canPublish =
    isValidationValid(session?.validation) &&
    canEdit &&
    missingCapabilities.length === 0 &&
    !turnActive

  const handleSend = (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault()
    if (!composer.trim() || turnActive || !canEdit) return
    send.mutate()
  }

  if (sessionQuery.isPending) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-10 w-64" />
        <Skeleton className="h-[70vh] w-full" />
      </div>
    )
  }

  if (sessionQuery.isError || !session) {
    return (
      <div className="space-y-4">
        <Button asChild variant="ghost">
          <Link to="/sessions">
            <ArrowLeft className="size-4" />
            Back
          </Link>
        </Button>
        <p className="text-destructive">Session not found.</p>
      </div>
    )
  }

  return (
    <div className="flex h-[calc(100dvh-8rem)] flex-col gap-4">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="min-w-0 space-y-1">
          <div className="flex flex-wrap items-center gap-2">
            <Button asChild variant="ghost" size="sm">
              <Link to="/sessions">
                <ArrowLeft className="size-4" />
                Sessions
              </Link>
            </Button>
            <h2 className="truncate text-xl font-bold">
              {session.title?.trim() || "Untitled session"}
            </h2>
            <Badge variant="outline">{session.status}</Badge>
            <Badge variant="secondary">rev {session.revision}</Badge>
            <Badge
              variant="outline"
              className={cn(
                connectionState === "connected" && "border-primary text-primary",
                connectionState === "disconnected" &&
                  "border-destructive text-destructive",
              )}
            >
              {connectionState}
            </Badge>
          </div>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Select
            value={
              session.assistantModel
                ? modelValue(
                    session.assistantModel.provider,
                    session.assistantModel.model,
                  )
                : undefined
            }
            onValueChange={(value) => {
              if (!value || !canEdit || turnActive || changeModel.isPending) return
              const current = session.assistantModel
                ? modelValue(
                    session.assistantModel.provider,
                    session.assistantModel.model,
                  )
                : ""
              if (value === current) return
              changeModel.mutate(value)
            }}
            disabled={!canEdit || turnActive || changeModel.isPending || models.length === 0}
          >
            <SelectTrigger className="min-w-56" size="sm">
              <SelectValue placeholder="Assistant model" />
            </SelectTrigger>
            <SelectContent>
              {models.map((option) => (
                <SelectItem
                  key={modelValue(option.provider, option.model)}
                  value={modelValue(option.provider, option.model)}
                >
                  {option.displayName}
                  {option.isDefault ? " (default)" : ""}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          {changeModel.isPending ? (
            <Loader2 className="size-4 animate-spin text-primary" />
          ) : null}
          <Button
            variant="outline"
            disabled={!canEdit || !session.draft || validate.isPending || turnActive}
            onClick={() => validate.mutate()}
          >
            {validate.isPending ? (
              <Loader2 className="size-4 animate-spin" />
            ) : null}
            Validate
          </Button>
          <AlertDialog open={publishOpen} onOpenChange={setPublishOpen}>
            <AlertDialogTrigger asChild>
              <Button
                disabled={!canPublish || publish.isPending}
                className="bg-gradient-primary text-primary-foreground"
              >
                Publish
              </Button>
            </AlertDialogTrigger>
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>Publish this draft?</AlertDialogTitle>
                <AlertDialogDescription>
                  Publishing creates an immutable catalog version for revision{" "}
                  {session.revision}. This is never automatic from chat.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>Cancel</AlertDialogCancel>
                <AlertDialogAction
                  onClick={() => publish.mutate()}
                  className="bg-gradient-primary text-primary-foreground"
                >
                  {publish.isPending ? (
                    <Loader2 className="size-4 animate-spin" />
                  ) : null}
                  Confirm publish
                </AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>
        </div>
      </div>

      {missingCapabilities.length > 0 ? (
        <div className="flex items-start gap-2 rounded-md border border-destructive/40 bg-destructive/10 p-3 text-sm text-destructive">
          <ShieldAlert className="mt-0.5 size-4 shrink-0" />
          <div>
            <p className="font-medium">Missing capabilities block publish</p>
            <p className="text-destructive/90">
              {missingCapabilities.join(", ")}
            </p>
          </div>
        </div>
      ) : null}

      <div className="hidden min-h-0 flex-1 gap-4 lg:grid lg:grid-cols-2">
        <ChatPanel
          session={session}
          composer={composer}
          setComposer={setComposer}
          turnActive={turnActive}
          activeTools={activeTools}
          deltaText={deltaText}
          canEdit={canEdit}
          onSend={handleSend}
          sending={send.isPending}
        />
        <DraftInspector session={session} />
      </div>

      <Tabs defaultValue="chat" className="min-h-0 flex-1 lg:hidden">
        <TabsList className="grid w-full grid-cols-2">
          <TabsTrigger value="chat">Chat</TabsTrigger>
          <TabsTrigger value="draft">Draft</TabsTrigger>
        </TabsList>
        <TabsContent value="chat" className="mt-3 h-[calc(100%-3rem)]">
          <ChatPanel
            session={session}
            composer={composer}
            setComposer={setComposer}
            turnActive={turnActive}
            activeTools={activeTools}
            deltaText={deltaText}
            canEdit={canEdit}
            onSend={handleSend}
            sending={send.isPending}
          />
        </TabsContent>
        <TabsContent value="draft" className="mt-3 h-[calc(100%-3rem)] overflow-y-auto">
          <DraftInspector session={session} />
        </TabsContent>
      </Tabs>
    </div>
  )
}

function ChatPanel({
  session,
  composer,
  setComposer,
  turnActive,
  activeTools,
  deltaText,
  canEdit,
  onSend,
  sending,
}: Readonly<{
  session: AuthoringSession
  composer: string
  setComposer: (value: string) => void
  turnActive: boolean
  activeTools: string[]
  deltaText: string | null
  canEdit: boolean
  onSend: (e: SyntheticEvent<HTMLFormElement>) => void
  sending: boolean
}>) {
  return (
    <Card className="flex h-full min-h-0 flex-col border-border/80">
      <CardHeader className="pb-3">
        <CardTitle className="text-base">Conversation</CardTitle>
        <CardDescription>
          Tool events are status indicators, not editable messages.
        </CardDescription>
      </CardHeader>
      <Separator />
      <CardContent className="flex min-h-0 flex-1 flex-col gap-3 p-4">
        <ScrollArea className="min-h-0 flex-1 pr-3">
          <div className="space-y-3">
            {session.messages.map((message) => {
              if (message.role === "Tool") {
                return (
                  <div
                    key={message.id}
                    className="inline-flex items-center gap-2 rounded-full border border-border bg-muted/50 px-3 py-1 text-xs text-muted-foreground"
                  >
                    <Wrench className="size-3" />
                    {message.toolName ?? "tool"} · {message.content}
                  </div>
                )
              }
              const isAdmin = message.role === "Admin"
              return (
                <div
                  key={message.id}
                  className={cn(
                    "max-w-[90%] rounded-lg border px-3 py-2 text-sm whitespace-pre-wrap",
                    isAdmin
                      ? "ml-auto border-primary/30 bg-primary/10"
                      : "border-border bg-card",
                  )}
                >
                  <p className="mb-1 text-[10px] uppercase tracking-widest text-muted-foreground">
                    {message.role}
                  </p>
                  {message.content}
                </div>
              )
            })}
            {deltaText ? (
              <div className="max-w-[90%] rounded-lg border border-border bg-card px-3 py-2 text-sm whitespace-pre-wrap opacity-80">
                <p className="mb-1 text-[10px] uppercase tracking-widest text-muted-foreground">
                  Assistant
                </p>
                {deltaText}
              </div>
            ) : null}
            {activeTools.map((name) => (
              <div
                key={name}
                className="inline-flex items-center gap-2 rounded-full border border-primary/30 bg-primary/10 px-3 py-1 text-xs text-primary"
              >
                <Loader2 className="size-3 animate-spin" />
                {name} running…
              </div>
            ))}
          </div>
        </ScrollArea>
        <form onSubmit={onSend} className="flex gap-2">
          <Textarea
            value={composer}
            onChange={(e) => setComposer(e.target.value)}
            placeholder={
              canEdit
                ? "Describe the preset you want…"
                : "This session is read-only"
            }
            disabled={!canEdit || turnActive || sending}
            className="min-h-20 resize-none"
          />
          <Button
            type="submit"
            size="icon"
            className="shrink-0 self-end bg-gradient-primary text-primary-foreground"
            disabled={!canEdit || turnActive || sending || !composer.trim()}
            aria-label="Send"
          >
            {turnActive || sending ? (
              <Loader2 className="size-4 animate-spin" />
            ) : (
              <Send className="size-4" />
            )}
          </Button>
        </form>
      </CardContent>
    </Card>
  )
}

function DraftInspector({
  session,
}: Readonly<{ session: AuthoringSession }>) {
  const draft = session.draft
  const errors = session.validation?.errors ?? []
  const errorsBySection = groupErrors(errors)

  return (
    <ScrollArea className="h-full rounded-xl border border-border/80 bg-card">
      <div className="space-y-4 p-4">
        <div>
          <h3 className="text-base font-bold">Draft inspector</h3>
          <p className="text-sm text-muted-foreground">
            Read-only view of the structured draft saved by the agent.
          </p>
        </div>

        {errors.length > 0 ? (
          <Card id="validation" className="border-destructive/40">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm text-destructive">
                Validation issues ({errors.length})
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-2 text-sm">
              {errors.map((issue) => (
                <div key={`${issue.path}-${issue.message}`}>
                  <p className="font-medium text-destructive">{issue.path}</p>
                  <p className="text-muted-foreground">{issue.message}</p>
                </div>
              ))}
            </CardContent>
          </Card>
        ) : (
          <Badge className="bg-primary/15 text-primary hover:bg-primary/15">
            No validation errors for current revision
          </Badge>
        )}

        {!draft ? (
          <p className="text-sm text-muted-foreground">
            No draft yet. Send a message to start authoring.
          </p>
        ) : (
          <>
            <DraftSection
              id="metadata"
              title="Metadata"
              errorCount={errorsBySection.metadata}
            >
              <Field label="Key" value={draft.key} />
              <Field label="Title" value={draft.title} />
              <Field label="Subtitle" value={draft.subtitle} />
              <Field label="Description" value={draft.description} />
              <Field
                label="Detailed description"
                value={draft.detailedDescription}
              />
              <Field
                label="Result contract"
                value={
                  draft.resultContractKey
                    ? `${draft.resultContractKey} v${draft.resultContractVersion ?? "?"}`
                    : "—"
                }
              />
            </DraftSection>

            <DraftSection
              id="inputs"
              title="Input schema"
              errorCount={errorsBySection.inputs}
            >
              <pre className="overflow-x-auto rounded-md border border-border bg-muted/40 p-3 text-xs text-muted-foreground">
                {prettyJson(draft.inputSchemaJson)}
              </pre>
            </DraftSection>

            <DraftSection
              id="agents"
              title={`Agents (${draft.agents.length})`}
              errorCount={errorsBySection.agents}
            >
              <div className="space-y-3">
                {draft.agents.map((agent) => (
                  <div
                    key={agent.key}
                    className="rounded-md border border-border p-3 text-sm"
                  >
                    <p className="font-medium">
                      {agent.name}{" "}
                      <span className="text-muted-foreground">({agent.key})</span>
                    </p>
                    <p className="mt-1 text-muted-foreground">
                      {agent.providerKey}/{agent.modelKey} · temp{" "}
                      {agent.defaultTemperature}
                    </p>
                    <p className="mt-2 whitespace-pre-wrap text-xs">
                      {agent.instructions}
                    </p>
                    <div className="mt-2 flex flex-wrap gap-1">
                      {agent.harness.planningEnabled ? (
                        <Badge variant="outline">planning</Badge>
                      ) : null}
                      {agent.harness.webSearchEnabled ? (
                        <Badge variant="outline">web search</Badge>
                      ) : null}
                      {agent.harness.requireToolApproval ? (
                        <Badge variant="outline">tool approval</Badge>
                      ) : null}
                      <Badge variant="outline">
                        max {agent.harness.maxIterations}
                      </Badge>
                    </div>
                  </div>
                ))}
              </div>
            </DraftSection>

            <DraftSection
              id="workflow"
              title={`Workflow · ${draft.workflow.key}`}
              errorCount={errorsBySection.workflow}
            >
              <div className="space-y-2">
                {(draft.workflow.nodes ?? []).map((node) => (
                  <div
                    key={node.key}
                    className="rounded-md border border-border p-3 text-sm"
                  >
                    <div className="flex flex-wrap items-center gap-2">
                      <p className="font-medium">{node.displayName}</p>
                      <Badge variant="outline">{String(node.type)}</Badge>
                      <Badge variant="secondary">{node.referenceKey}</Badge>
                    </div>
                    <p className="mt-1 text-xs text-muted-foreground">
                      pos {node.position}
                      {node.requiresHumanApproval ? " · human approval" : ""}
                    </p>
                    <pre className="mt-2 overflow-x-auto text-xs text-muted-foreground">
                      {prettyJson(node.inputMappingJson)}
                    </pre>
                  </div>
                ))}
                <Separator />
                <p className="text-xs uppercase tracking-widest text-muted-foreground">
                  Connections
                </p>
                {(draft.workflow.connections ?? []).map((edge, index) => (
                  <p key={`${edge.sourceNodeKey}-${edge.targetNodeKey}-${index}`} className="text-sm">
                    {edge.sourceNodeKey} → {edge.targetNodeKey}
                  </p>
                ))}
              </div>
            </DraftSection>

            <DraftSection
              id="background"
              title="Background policy"
              errorCount={errorsBySection.background}
            >
              <Field
                label="Mode"
                value={String(draft.backgroundExecution.mode)}
              />
              <Field
                label="Rationale"
                value={draft.backgroundExecution.rationale}
              />
              <Field
                label="Triggers"
                value={
                  draft.backgroundExecution.allowedTriggerTypes?.join(", ") ||
                  "—"
                }
              />
            </DraftSection>

            <DraftSection
              id="admin-notes"
              title={`Admin notes (${draft.adminNotes.length})`}
              errorCount={errorsBySection.adminNotes}
            >
              {draft.adminNotes.length === 0 ? (
                <p className="text-sm text-muted-foreground">None</p>
              ) : (
                draft.adminNotes.map((note, index) => (
                  <div
                    key={`${note.title}-${index}`}
                    className="rounded-md border border-border p-3 text-sm"
                  >
                    <div className="mb-1 flex items-center gap-2">
                      <p className="font-medium">{note.title}</p>
                      <Badge variant="outline">{String(note.severity)}</Badge>
                    </div>
                    <p className="text-muted-foreground">{note.description}</p>
                  </div>
                ))
              )}
            </DraftSection>
          </>
        )}
      </div>
    </ScrollArea>
  )
}

function DraftSection({
  id,
  title,
  errorCount,
  children,
}: Readonly<{
  id: string
  title: string
  errorCount: number
  children: ReactNode
}>) {
  return (
    <Card id={id}>
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between gap-2">
          <CardTitle className="text-sm">{title}</CardTitle>
          {errorCount > 0 ? (
            <Badge variant="destructive">{errorCount}</Badge>
          ) : null}
        </div>
      </CardHeader>
      <CardContent className="space-y-2">{children}</CardContent>
    </Card>
  )
}

function Field({
  label,
  value,
}: Readonly<{ label: string; value: string }>) {
  return (
    <div className="grid gap-1 sm:grid-cols-[7rem_1fr]">
      <span className="text-xs uppercase tracking-widest text-muted-foreground">
        {label}
      </span>
      <span className="text-sm break-words whitespace-pre-wrap">
        {value || "—"}
      </span>
    </div>
  )
}

function prettyJson(value: string) {
  try {
    return JSON.stringify(JSON.parse(value), null, 2)
  } catch {
    return value || "—"
  }
}

function groupErrors(errors: ValidationIssue[]) {
  const counts = {
    metadata: 0,
    inputs: 0,
    agents: 0,
    workflow: 0,
    background: 0,
    adminNotes: 0,
  }
  for (const issue of errors) {
    const path = issue.path.toLowerCase()
    if (path.includes("agent")) counts.agents += 1
    else if (path.includes("workflow") || path.includes("node") || path.includes("connection"))
      counts.workflow += 1
    else if (path.includes("input") || path.includes("schema")) counts.inputs += 1
    else if (path.includes("background")) counts.background += 1
    else if (path.includes("admin") || path.includes("note")) counts.adminNotes += 1
    else counts.metadata += 1
  }
  return counts
}
