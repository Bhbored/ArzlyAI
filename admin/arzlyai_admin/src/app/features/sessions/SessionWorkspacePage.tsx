import {
  lazy,
  Suspense,
  useMemo,
  useRef,
  useState,
  type ReactNode,
  type SyntheticEvent,
} from "react";
import { Link, useParams, useSearchParams } from "react-router-dom";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { ArrowLeft, Loader2, Send, ShieldAlert, Wrench } from "lucide-react";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
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
} from "@/components/ui/alert-dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { cn } from "@/lib/utils";
import { ApiError } from "../../shared/api/http";
import type {
  AuthoringSession,
  Capability,
  PresetDraft,
  ValidationIssue,
} from "../../shared/types";
import { isValidationValid } from "../../shared/types";
import { capabilityQueries } from "../capabilities/capabilities.service";
import { presetKeys } from "../presets/presets.service";
import {
  fetchSession,
  publishSession,
  sendMessage,
  sessionKeys,
  sessionQueries,
  setAssistantModel,
  validateSession,
} from "./sessions.service";
import { useAuthoringHub } from "./useAuthoringHub";
import { enumName, nodeTypes } from "./draftEditorModel";

const DraftEditor = lazy(() => import("./DraftEditor").then(module => ({ default: module.DraftEditor })));

const Markdown = lazy(() =>
  import("../../shared/components/Markdown").then((module) => ({
    default: module.Markdown,
  })),
);

function modelValue(provider: string, model: string) {
  return `${provider}::${model}`;
}

function parseModelValue(value: string) {
  const sep = value.indexOf("::");
  if (sep < 0) return null;
  return {
    provider: value.slice(0, sep),
    model: value.slice(sep + 2),
  };
}

export default function SessionWorkspacePage() {
  const { id = "" } = useParams();
  const queryClient = useQueryClient();
  const [composer, setComposer] = useState("");
  const [turnActive, setTurnActive] = useState(false);
  const [partialReply, setPartialReply] = useState({ sessionId: "", text: "" });
  const [activeTools, setActiveTools] = useState<string[]>([]);
  const [publishOpen, setPublishOpen] = useState(false);
  const [editorDirty, setEditorDirty] = useState(false);
  const [workspaceParams, setWorkspaceParams] = useSearchParams();
  const workspaceTab = workspaceParams.get("tab") === "builder" ? "builder" : workspaceParams.get("tab") === "review" ? "review" : "chat";
  const sendInFlightRef = useRef(false);
  const requestIdRef = useRef<{ id: string; content: string } | null>(null);

  const sessionQuery = useQuery({
    ...sessionQueries.detail(id),
    enabled: Boolean(id),
    refetchInterval: (query) => query.state.data?.turn?.status === "Running" ? 2000 : false,
  });
  const modelsQuery = useQuery(sessionQueries.models());
  const capabilitiesQuery = useQuery(capabilityQueries.list());

  const session = sessionQuery.data;
  const busy = turnActive || session?.turn?.status === "Running";
  const models = modelsQuery.data ?? [];
  const capabilityKeys = useMemo(
    () => new Set((capabilitiesQuery.data ?? []).map((c) => c.key)),
    [capabilitiesQuery.data],
  );

  const missingCapabilities = useMemo(() => {
    const draft = session?.draft;
    if (!draft) return [] as string[];
    const refs = new Set<string>();
    for (const node of draft.workflow?.nodes ?? []) {
      if (node.referenceKey && ["Integration", "Operation"].includes(enumName(node.type, nodeTypes))) refs.add(node.referenceKey);
    }
    return [...refs].filter((key) => !capabilityKeys.has(key));
  }, [session?.draft, capabilityKeys]);

  const { connectionState } = useAuthoringHub(id || undefined, {
    onAssistantTextUpdated: (text) => setPartialReply({ sessionId: id, text }),
    onReconnected: () => {
      if (!sendInFlightRef.current) {
        setTurnActive(false);
        setActiveTools([]);
        setPartialReply({ sessionId: id, text: "" });
      }
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) });
    },
    onTurnStarted: () => {
      setPartialReply({ sessionId: id, text: "" });
      setTurnActive(true);
      setActiveTools([]);
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) });
    },
    onToolStarted: (name) =>
      setActiveTools((prev) => (prev.includes(name) ? prev : [...prev, name])),
    onToolCompleted: (name) =>
      setActiveTools((prev) => prev.filter((item) => item !== name)),
    onDraftUpdated: () => {
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) });
    },
    onValidationChanged: () => {
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) });
    },
    onTurnCompleted: (result) => {
      setPartialReply({ sessionId: id, text: "" });
      setTurnActive(false);
      setActiveTools([]);
      queryClient.setQueryData(sessionKeys.detail(id), result.session);
      void queryClient.invalidateQueries({ queryKey: sessionKeys.list() });
    },
    onTurnFailed: (message) => {
      setPartialReply({ sessionId: id, text: "" });
      setTurnActive(false);
      setActiveTools([]);
      if (!sendInFlightRef.current) toast.error("Authoring turn failed", { description: message });
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) });
    },
  });

  const changeModel = useMutation({
    mutationFn: (value: string) => {
      if (!session) throw new Error("Chat not loaded");
      const parsed = parseModelValue(value);
      if (!parsed) throw new Error("Invalid model selection");
      return setAssistantModel(
        session.id,
        parsed.provider,
        parsed.model,
        session.revision,
      );
    },
    onSuccess: (next) => {
      queryClient.setQueryData(sessionKeys.detail(id), next);
      void queryClient.invalidateQueries({ queryKey: sessionKeys.list() });
      toast.success("Assistant model updated");
    },
    onError: (error) => {
      if (error instanceof ApiError && error.status === 409) {
        toast.error("Stale revision", {
          description: "Reloading the chat.",
        });
        void queryClient.invalidateQueries({
          queryKey: sessionKeys.detail(id),
        });
        return;
      }
      if (error instanceof ApiError && error.status === 400) {
        toast.error("Assistant model unavailable", {
          description:
            error.message ||
            "The model is unavailable, disabled, unconfigured, or unsupported for tool calling.",
        });
        void queryClient.invalidateQueries({ queryKey: sessionKeys.models() });
        return;
      }
      toast.error("Could not change assistant model", {
        description: error instanceof Error ? error.message : undefined,
      });
    },
  });

  const send = useMutation({
    mutationFn: (content: string) => {
      if (!session) throw new Error("Chat not loaded");
      const existing = requestIdRef.current;
      const requestId = existing?.content === content ? existing.id : crypto.randomUUID();
      requestIdRef.current = { id: requestId, content };
      return sendMessage(session.id, content, session.revision, requestId);
    },
    onSuccess: (result) => {
      setPartialReply({ sessionId: id, text: "" });
      setComposer("");
      requestIdRef.current = null;
      setTurnActive(false);
      queryClient.setQueryData(sessionKeys.detail(id), result.session);
      void queryClient.invalidateQueries({ queryKey: sessionKeys.list() });
    },
    onError: async (error) => {
      setPartialReply({ sessionId: id, text: "" });
      setActiveTools([]);
      void queryClient.invalidateQueries({ queryKey: sessionKeys.detail(id) });
      setTurnActive(false);
      if (error instanceof ApiError && error.status === 408) {
        toast.error("Authoring turn timed out", {
          description:
            "The server exceeded its five-minute limit. Reloading the chat.",
        });
        void queryClient.invalidateQueries({
          queryKey: sessionKeys.detail(id),
        });
        return;
      }
      if (error instanceof ApiError && error.status === 409) {
        try {
          const next = await fetchSession(id);
          queryClient.setQueryData(sessionKeys.detail(id), next);
        } catch {
          void queryClient.invalidateQueries({
            queryKey: sessionKeys.detail(id),
          });
        }
        toast.error("Chat changed", {
          description:
            "Review the current draft, then submit your message again.",
        });
        return;
      }
      toast.error("Could not send message", {
        description: error instanceof Error ? error.message : undefined,
      });
    },
    onSettled: () => {
      sendInFlightRef.current = false;
    },
  });

  const validate = useMutation({
    mutationFn: () => validateSession(id),
    onSuccess: (next) => {
      queryClient.setQueryData(sessionKeys.detail(id), next);
      toast.success(
        isValidationValid(next.validation)
          ? "Draft is valid"
          : "Validation found issues",
      );
    },
    onError: (error) => {
      if (error instanceof ApiError && error.status === 409) {
        void queryClient.invalidateQueries({
          queryKey: sessionKeys.detail(id),
        });
      }
      toast.error("Validation failed", {
        description: error instanceof Error ? error.message : undefined,
      });
    },
  });

  const publish = useMutation({
    mutationFn: () => {
      if (!session) throw new Error("Chat not loaded");
      return publishSession(session.id, session.revision);
    },
    onSuccess: async (result) => {
      toast.success("Preset published", {
        description: `Preset id ${result.presetId}`,
      });
      setPublishOpen(false);
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: sessionKeys.all }),
        queryClient.invalidateQueries({ queryKey: presetKeys.all }),
      ]);
    },
    onError: (error) => {
      if (error instanceof ApiError && error.status === 422) {
        toast.error("Publish blocked by validation", {
          description: error.validation
            ?.map((issue) => `${issue.path}: ${issue.message}`)
            .join(" · "),
        });
        void queryClient.invalidateQueries({
          queryKey: sessionKeys.detail(id),
        });
        return;
      }
      if (error instanceof ApiError && error.status === 409) {
        toast.error("Stale revision", {
          description: "Reloading the chat.",
        });
        void queryClient.invalidateQueries({
          queryKey: sessionKeys.detail(id),
        });
        return;
      }
      toast.error("Could not publish", {
        description: error instanceof Error ? error.message : undefined,
      });
    },
  });

  const canEdit =
    session?.status === "Active" || session?.status === "ReadyToPublish";
  const canPublish =
    isValidationValid(session?.validation) &&
    Boolean(session?.publishReadiness?.canPublish) &&
    canEdit &&
    missingCapabilities.length === 0 &&
    !busy && !editorDirty;

  const handleSend = (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (
      !composer.trim() ||
      !canEdit ||
      editorDirty ||
      busy ||
      send.isPending ||
      sendInFlightRef.current
    ) {
      return;
    }
    sendInFlightRef.current = true;
    setTurnActive(true);
    setPartialReply({ sessionId: id, text: "" });
    send.mutate(composer.trim());
  };

  if (sessionQuery.isPending) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-10 w-64" />
        <Skeleton className="h-[70vh] w-full" />
      </div>
    );
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
        <p className="text-destructive">{sessionQuery.error instanceof ApiError && sessionQuery.error.status === 404
          ? "Chat not found."
          : "Could not load this chat. Check your connection and try again."}</p>
        {!(sessionQuery.error instanceof ApiError && sessionQuery.error.status === 404) &&
          <Button variant="outline" onClick={() => void sessionQuery.refetch()}>Retry</Button>}
      </div>
    );
  }

  return (
    <div className="flex min-h-[calc(100dvh-8rem)] flex-col gap-4">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="min-w-0 space-y-1">
          <div className="flex flex-wrap items-center gap-2">
            <Button asChild variant="ghost" size="sm">
              <Link to="/sessions">
                <ArrowLeft className="size-4" />
                Chats
              </Link>
            </Button>
            <h2 className="truncate text-xl font-bold">
              {session.title?.trim() || "Untitled chat"}
            </h2>
            <Badge variant="outline">{session.status}</Badge>
            <Badge variant="secondary">rev {session.revision}</Badge>
            <Badge
              variant="outline"
              className={cn(
                connectionState === "connected" &&
                  "border-primary text-primary",
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
              if (!value || !canEdit || busy || editorDirty || changeModel.isPending)
                return;
              const current = session.assistantModel
                ? modelValue(
                    session.assistantModel.provider,
                    session.assistantModel.model,
                  )
                : "";
              if (value === current) return;
              changeModel.mutate(value);
            }}
            disabled={
              !canEdit ||
              busy || editorDirty ||
              changeModel.isPending ||
              models.length === 0
            }
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
            disabled={
              !canEdit || !session.draft || validate.isPending || busy || editorDirty
            }
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

      {!canPublish && session.publishReadiness?.blockers?.length > 0 && <div className="rounded-md border border-border bg-muted/30 p-3 text-sm" role="status">
        <p className="font-medium">Before publishing</p>
        <ul className="list-inside list-disc">{session.publishReadiness.blockers.map(blocker => <li key={blocker}>{blocker}</li>)}</ul>
      </div>}
      {connectionState !== "connected" && <p className="rounded-md border border-border p-3 text-sm text-muted-foreground" role="status">
        Live updates are {connectionState}. You can still send a message; the saved reply will appear when the request finishes.
      </p>}
      {editorDirty && <p className="rounded-md border border-primary/40 p-3 text-sm" role="status">Save or discard your editor changes before chatting or publishing.</p>}

      <Tabs value={workspaceTab} onValueChange={tab => setWorkspaceParams(previous => {
        const next = new URLSearchParams(previous); next.set("tab", tab); return next;
      }, { replace: true })} className="min-w-0 flex-1">
        <TabsList aria-label="Workspace" className="!h-auto min-h-12 w-full justify-start border-b bg-transparent sm:w-fit">
          <TabsTrigger value="chat" className="min-h-11 px-4">Chat</TabsTrigger>
          <TabsTrigger value="builder" className="min-h-11 px-4">Workflow builder{editorDirty ? " *" : ""}</TabsTrigger>
          <TabsTrigger value="review" className="min-h-11 px-4">Review</TabsTrigger>
        </TabsList>
        <TabsContent value="chat" forceMount className="min-w-0 data-[state=inactive]:hidden">
          <div className="h-[max(32rem,calc(100dvh-19rem))] min-w-0"><ChatPanel
          session={session}
          partialReply={partialReply.sessionId === id ? partialReply.text : ""}
          composer={composer}
          setComposer={setComposer}
          turnActive={busy}
          activeTools={activeTools}
          canEdit={canEdit && !editorDirty}
          onSend={handleSend}
          sending={send.isPending}
        /></div></TabsContent>
        <TabsContent value="builder" forceMount className="min-w-0 data-[state=inactive]:hidden">
          <Suspense fallback={<p className="p-6 text-sm text-muted-foreground">Loading workflow builder…</p>}>
          <DraftEditor key={session.id} session={session} capabilities={capabilitiesQuery.data ?? []}
            locked={busy} onDirtyChange={setEditorDirty} />
          </Suspense>
        </TabsContent>
        <TabsContent value="review" className="min-w-0"><DraftInspector session={session} capabilities={capabilitiesQuery.data ?? []} /></TabsContent>
      </Tabs>
    </div>
  );
}

function ChatPanel({
  session,
  partialReply,
  composer,
  setComposer,
  turnActive,
  activeTools,
  canEdit,
  onSend,
  sending,
}: Readonly<{
  session: AuthoringSession;
  partialReply: string;
  composer: string;
  setComposer: (value: string) => void;
  turnActive: boolean;
  activeTools: string[];
  canEdit: boolean;
  onSend: (e: SyntheticEvent<HTMLFormElement>) => void;
  sending: boolean;
}>) {
  return (
    <Card className="flex h-full min-h-0 min-w-0 flex-col border-border/80">
      <CardHeader className="pb-3">
        <CardTitle className="text-base">Conversation</CardTitle>
        <CardDescription>
          Describe the workflow you want, then refine it in the builder.
        </CardDescription>
      </CardHeader>
      <Separator />
      <CardContent className="flex min-h-0 min-w-0 flex-1 flex-col gap-3 p-3 sm:p-5">
        <div className="min-h-0 min-w-0 flex-1 overflow-y-auto overscroll-contain pr-2" role="region" aria-label="Chat messages" tabIndex={0}>
          <div className="mx-auto w-full min-w-0 max-w-4xl space-y-4 pb-3 [overflow-wrap:anywhere]">
            {session.messages.length === 0 && <p className="py-8 text-sm text-muted-foreground">Start with what your workflow should do, the information it needs, and the result you want.</p>}
            {session.messages.map((message) => {
              if (message.role === "Tool") {
                return (
                  <div
                    key={message.id}
                    className="flex min-w-0 items-start gap-2 rounded-md border border-border bg-muted/50 px-3 py-2 text-xs text-muted-foreground"
                  >
                    <Wrench className="mt-0.5 size-3 shrink-0" />
                    <span className="min-w-0 whitespace-pre-wrap">{message.toolName ?? "tool"} · {message.content}</span>
                  </div>
                );
              }
              const isAdmin = message.role === "Admin";
              return (
                <div
                  key={message.id}
                  className={cn(
                    "min-w-0 max-w-full rounded-lg border px-4 py-3 text-sm sm:max-w-[94%]",
                    isAdmin
                      ? "ml-auto border-primary/30 bg-primary/10 whitespace-pre-wrap"
                      : "border-border bg-card",
                  )}
                >
                  <p className="mb-1 text-[10px] uppercase tracking-widest text-muted-foreground">
                    {message.role}
                  </p>
                  {isAdmin ? (
                    message.content
                  ) : (
                    <Suspense
                      fallback={
                        <span className="whitespace-pre-wrap">
                          {message.content}
                        </span>
                      }
                    >
                      <Markdown>{message.content}</Markdown>
                    </Suspense>
                  )}
                </div>
              );
            })}
            {partialReply && turnActive && (
              <div className="min-w-0 max-w-full rounded-lg border border-border bg-card px-4 py-3 text-sm sm:max-w-[94%]" aria-busy="true">
                <p className="mb-1 text-xs text-muted-foreground">Assistant · Writing…</p>
                <div className="whitespace-pre-wrap break-words">{partialReply}</div>
              </div>
            )}
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
        </div>
        <form onSubmit={onSend} className="mx-auto flex w-full min-w-0 max-w-4xl gap-2 border-t pt-3">
          <Textarea
            value={composer}
            onChange={(e) => setComposer(e.target.value)}
            placeholder={
              canEdit
                ? "Describe the preset you want…"
                : "This chat is read-only"
            }
            disabled={!canEdit || turnActive || sending}
            aria-label="Message"
            className="min-h-20 min-w-0 resize-none"
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
  );
}

function DraftInspector({
  session,
  capabilities,
}: Readonly<{
  session: AuthoringSession;
  capabilities: Capability[];
}>) {
  const draft = session.draft;
  const errors = session.validation?.errors ?? [];
  const errorsBySection = groupErrors(errors);
  const connectorRequirements = useMemo(
    () => collectConnectorRequirements(draft, capabilities),
    [draft, capabilities],
  );

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
              {errors.map((issue) => {
                const sectionId = sectionIdForPath(issue.path);
                return (
                  <div key={`${issue.path}-${issue.message}`}>
                    <a
                      href={`#${sectionId}`}
                      className="font-medium text-destructive underline-offset-2 hover:underline"
                    >
                      {issue.path}
                    </a>
                    <p className="text-muted-foreground">{issue.message}</p>
                  </div>
                );
              })}
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
                      <span className="text-muted-foreground">
                        ({agent.key})
                      </span>
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
                      {agent.harness.todoTrackingEnabled ? (
                        <Badge variant="outline">todo tracking</Badge>
                      ) : null}
                      {agent.harness.contextCompactionEnabled ? (
                        <Badge variant="outline">context compaction</Badge>
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
                  <p
                    key={`${edge.sourceNodeKey}-${edge.targetNodeKey}-${index}`}
                    className="text-sm"
                  >
                    {edge.sourceNodeKey} → {edge.targetNodeKey}
                  </p>
                ))}
              </div>
            </DraftSection>

            <DraftSection
              id="connectors"
              title={`Connector requirements (${connectorRequirements.length})`}
              errorCount={errorsBySection.connectors}
            >
              {connectorRequirements.length === 0 ? (
                <p className="text-sm text-muted-foreground">
                  No integration nodes in this draft.
                </p>
              ) : (
                <div className="space-y-3">
                  {connectorRequirements.map((item) => (
                    <div
                      key={item.capabilityKey}
                      className="rounded-md border border-border p-3 text-sm"
                    >
                      <div className="mb-1 flex flex-wrap items-center gap-2">
                        <p className="font-medium">{item.displayName}</p>
                        <Badge variant="secondary">{item.capabilityKey}</Badge>
                        {item.missing ? (
                          <Badge variant="destructive">missing</Badge>
                        ) : null}
                      </div>
                      <Field
                        label="Connector"
                        value={item.connectorKey ?? "—"}
                      />
                      <Field label="Risk" value={item.riskLevel || "—"} />
                      <Field
                        label="OAuth scopes"
                        value={item.scopes.join(", ") || "—"}
                      />
                      <Field
                        label="Required APIs"
                        value={item.apis.join(", ") || "—"}
                      />
                      <Field
                        label="Used by nodes"
                        value={item.nodeKeys.join(", ") || "—"}
                      />
                    </div>
                  ))}
                </div>
              )}
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
              errorCount={errorsBySection["admin-notes"]}
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
  );
}

function DraftSection({
  id,
  title,
  errorCount,
  children,
}: Readonly<{
  id: string;
  title: string;
  errorCount: number;
  children: ReactNode;
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
  );
}

function Field({ label, value }: Readonly<{ label: string; value: string }>) {
  return (
    <div className="grid gap-1 sm:grid-cols-[7rem_1fr]">
      <span className="text-xs uppercase tracking-widest text-muted-foreground">
        {label}
      </span>
      <span className="text-sm wrap-break-word whitespace-pre-wrap">
        {value || "—"}
      </span>
    </div>
  );
}

function prettyJson(value: string) {
  try {
    return JSON.stringify(JSON.parse(value), null, 2);
  } catch {
    return value || "—";
  }
}

type DraftSectionId =
  | "metadata"
  | "inputs"
  | "agents"
  | "workflow"
  | "connectors"
  | "background"
  | "admin-notes";

function sectionIdForPath(path: string): DraftSectionId {
  const normalized = path.toLowerCase();
  if (normalized.includes("agent") || normalized.includes("harness"))
    return "agents";
  if (
    normalized.includes("workflow") ||
    normalized.includes("node") ||
    normalized.includes("connection")
  )
    return "workflow";
  if (normalized.includes("integration") || normalized.includes("connector"))
    return "connectors";
  if (normalized.includes("input") || normalized.includes("schema"))
    return "inputs";
  if (normalized.includes("background")) return "background";
  if (normalized.includes("admin") || normalized.includes("note"))
    return "admin-notes";
  return "metadata";
}

function groupErrors(errors: ValidationIssue[]) {
  const counts: Record<DraftSectionId, number> = {
    metadata: 0,
    inputs: 0,
    agents: 0,
    workflow: 0,
    connectors: 0,
    background: 0,
    "admin-notes": 0,
  };
  for (const issue of errors) {
    const section = sectionIdForPath(issue.path);
    // Integration availability errors also belong on the connectors card.
    if (
      issue.path.toLowerCase().includes("referencekey") &&
      issue.message.toLowerCase().includes("integration")
    ) {
      counts.connectors += 1;
      counts.workflow += 1;
      continue;
    }
    counts[section] += 1;
  }
  return counts;
}

function parseJsonStringArray(value: string | null | undefined): string[] {
  if (!value) return [];
  try {
    const parsed = JSON.parse(value) as unknown;
    return Array.isArray(parsed)
      ? parsed.filter((item): item is string => typeof item === "string")
      : [];
  } catch {
    return [];
  }
}

function isIntegrationNodeType(type: number | string): boolean {
  if (typeof type === "number") return type === 2;
  const normalized = type.toLowerCase();
  return normalized === "integration" || normalized === "2";
}

interface ConnectorRequirement {
  capabilityKey: string;
  displayName: string;
  connectorKey: string | null;
  riskLevel: string;
  scopes: string[];
  apis: string[];
  nodeKeys: string[];
  missing: boolean;
}

function collectConnectorRequirements(
  draft: PresetDraft | null | undefined,
  capabilities: Capability[],
): ConnectorRequirement[] {
  if (!draft) return [];
  const byKey = new Map(
    capabilities.map((capability) => [capability.key, capability]),
  );
  const grouped = new Map<string, ConnectorRequirement>();

  for (const node of draft.workflow.nodes ?? []) {
    if (!isIntegrationNodeType(node.type)) continue;
    const existing = grouped.get(node.referenceKey);
    if (existing) {
      existing.nodeKeys.push(node.key);
      continue;
    }
    const capability = byKey.get(node.referenceKey);
    grouped.set(node.referenceKey, {
      capabilityKey: node.referenceKey,
      displayName: capability?.displayName ?? node.referenceKey,
      connectorKey: capability?.connectorKey ?? null,
      riskLevel: capability?.riskLevel ?? "",
      scopes: parseJsonStringArray(capability?.requiredOAuthScopesJson),
      apis: parseJsonStringArray(capability?.requiredApisJson),
      nodeKeys: [node.key],
      missing: !capability,
    });
  }

  return [...grouped.values()].sort((a, b) =>
    a.capabilityKey.localeCompare(b.capabilityKey),
  );
}
