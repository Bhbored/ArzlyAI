import { useMemo, useState } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Archive, Loader2, Plus, RotateCcw, Trash2 } from "lucide-react";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Skeleton } from "@/components/ui/skeleton";
import type { AuthoringProvider, AuthoringSessionSummary } from "../../shared/types";
import { ApiError } from "../../shared/api/http";
import { PageHeader } from "../../shared/components/PageHeader";
import { DataTableShell } from "../../shared/components/DataTableShell";
import { ProviderIcon } from "../../shared/components/ProviderIcon";
import {
  abandonSession,
  createSession,
  deleteSessionPermanently,
  restoreSession,
  sessionKeys,
  sessionQueries,
} from "./sessions.service";

function findDefaultSelection(providers: AuthoringProvider[]) {
  for (const provider of providers) {
    if (!provider.isAvailable) continue;
    const model = provider.models.find(
      (candidate) =>
        candidate.isDefault &&
        candidate.isAvailable &&
        candidate.supportsToolCalling,
    );
    if (model) return { provider: provider.provider, model: model.model };
  }
  return null;
}

function unavailableReasonLabel(reason: string | null) {
  switch (reason) {
    case "provider_disabled":
      return "Disabled in server configuration.";
    case "missing_api_key":
      return "No API key is configured.";
    case "model_client_unavailable":
      return "The provider client is unavailable.";
    case "model_catalog_unavailable":
      return "The model catalog could not be loaded.";
    case "no_function_calling_models":
      return "No tool-calling models are available.";
    default:
      return reason ?? "Unavailable.";
  }
}

export default function SessionsPage() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const queryClient = useQueryClient();
  const sessionsQuery = useQuery(sessionQueries.list());
  const providersQuery = useQuery(sessionQueries.providers());
  const [panelOpen, setPanelOpen] = useState(() => searchParams.has("new"));
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [title, setTitle] = useState("");
  const [selectedProvider, setSelectedProvider] = useState<string | null>(null);
  const [selectedModel, setSelectedModel] = useState<string | null>(null);
  const [abandonTarget, setAbandonTarget] = useState<AuthoringSessionSummary | null>(
    null,
  );
  const [deleteTarget, setDeleteTarget] = useState<AuthoringSessionSummary | null>(
    null,
  );

  const providers = providersQuery.data ?? [];
  const defaultSelection = findDefaultSelection(providers);

  const selection = selectedProvider
    ? { provider: selectedProvider, model: selectedModel }
    : defaultSelection;

  const activeProvider = selection
    ? providers.find((provider) => provider.provider === selection.provider) ??
      null
    : null;

  const activeModel =
    activeProvider && selection
      ? activeProvider.models.find((model) => model.model === selection.model) ??
        null
      : null;

  const canCreate = Boolean(
    activeProvider?.isAvailable &&
      activeModel?.isAvailable &&
      activeModel?.supportsToolCalling,
  );

  const unavailableProviders = providers.filter(
    (provider) => !provider.isAvailable,
  );

  const handleProviderChange = (providerKey: string) => {
    const provider = providers.find(
      (candidate) => candidate.provider === providerKey,
    );
    const firstUsable = provider?.models.find(
      (model) => model.isAvailable && model.supportsToolCalling,
    );
    setSelectedProvider(providerKey);
    setSelectedModel(firstUsable ? firstUsable.model : null);
  };

  const resetPickers = () => {
    setSelectedProvider(null);
    setSelectedModel(null);
  };

  const create = useMutation({
    mutationFn: () => {
      if (!canCreate || !selection) {
        throw new Error("Select an available model before creating a chat.");
      }
      return createSession(title, selection.provider, selection.model);
    },
    onSuccess: async (session) => {
      await queryClient.invalidateQueries({ queryKey: sessionKeys.all });
      toast.success("Chat created");
      setPanelOpen(false);
      setTitle("");
      resetPickers();
      navigate(`/sessions/${session.id}`);
    },
    onError: (error) =>
      toast.error("Could not create chat", {
        description: error instanceof Error ? error.message : undefined,
      }),
  });

  const abandon = useMutation({
    mutationFn: (id: string) => abandonSession(id),
    onSuccess: async (updated) => {
      queryClient.setQueryData(sessionKeys.detail(updated.id), updated);
      await queryClient.invalidateQueries({ queryKey: sessionKeys.list() });
      toast.success("Chat abandoned");
      setAbandonTarget(null);
    },
    onError: (error) =>
      toast.error("Could not abandon chat", {
        description:
          error instanceof ApiError ? error.message : "Unexpected error",
      }),
  });

  const restore = useMutation({
    mutationFn: (id: string) => restoreSession(id),
    onSuccess: async (updated) => {
      queryClient.setQueryData(sessionKeys.detail(updated.id), updated);
      await queryClient.invalidateQueries({ queryKey: sessionKeys.list() });
      toast.success("Chat restored");
    },
    onError: (error) => {
      if (error instanceof ApiError && error.status === 409) {
        void queryClient.invalidateQueries({ queryKey: sessionKeys.list() });
      }
      toast.error("Could not restore chat", {
        description:
          error instanceof ApiError ? error.message : "Unexpected error",
      });
    },
  });

  const remove = useMutation({
    mutationFn: (id: string) => deleteSessionPermanently(id),
    onSuccess: async (_result, id) => {
      queryClient.removeQueries({ queryKey: sessionKeys.detail(id) });
      await queryClient.invalidateQueries({ queryKey: sessionKeys.list() });
      toast.success("Chat deleted");
      setDeleteTarget(null);
    },
    onError: (error) =>
      toast.error("Could not delete chat", {
        description:
          error instanceof ApiError ? error.message : "Unexpected error",
      }),
  });

  const sessions = useMemo(() => (sessionsQuery.data ?? []).filter(session =>
    (statusFilter === "all" || session.status === statusFilter) &&
    `${session.title ?? ""} ${session.assistantModel.provider} ${session.assistantModel.model}`
      .toLowerCase().includes(search.toLowerCase().trim())), [sessionsQuery.data, statusFilter, search]);

  return (
    <div className="space-y-6">
      <PageHeader
        title="Authoring chats"
        description="Chat with the authoring agent to draft presets, then validate and publish."
        actions={
          <Button
            onClick={() => setPanelOpen(true)}
            className="bg-gradient-primary text-primary-foreground"
          >
            <Plus className="size-4" />
            New chat
          </Button>
        }
      />

      <DataTableShell title="Chats" toolbar={<div className="flex flex-wrap gap-2">
        <Input aria-label="Search chats" placeholder="Search chats" value={search} onChange={event => setSearch(event.target.value)} className="w-48" />
        <select aria-label="Filter chat status" value={statusFilter} onChange={event => setStatusFilter(event.target.value)}
          className="h-10 rounded-md border border-input bg-background px-3 text-sm">
          <option value="all">All statuses</option>
          {["Active", "ReadyToPublish", "Published", "Abandoned"].map(status => <option key={status} value={status}>{status}</option>)}
        </select>
      </div>}>
        {sessionsQuery.isPending ? (
          <div className="space-y-2 p-4">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : sessionsQuery.isError ? (
          <div className="p-6 text-sm text-destructive">Could not load chats. <Button type="button" variant="outline" size="sm" onClick={() => void sessionsQuery.refetch()}>Retry</Button></div>
        ) : sessions.length === 0 ? (
          <p className="p-6 text-sm text-muted-foreground">
            {search || statusFilter !== "all" ? "No chats match these filters." : "No chats yet. Create one to start drafting."}
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
                      {session.title?.trim() || "Untitled chat"}
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
                    <div className="flex items-center justify-end gap-1">
                      {session.status === "Active" ||
                      session.status === "ReadyToPublish" ? (
                        <Button
                          type="button"
                          variant="ghost"
                          size="icon"
                          className="text-muted-foreground hover:text-foreground"
                          disabled={
                            abandon.isPending &&
                            abandon.variables === session.id
                          }
                          onClick={() => setAbandonTarget(session)}
                          aria-label="Abandon chat"
                          title="Abandon chat"
                        >
                          <Archive className="size-4" />
                        </Button>
                      ) : null}
                      {session.status === "Abandoned" ? (
                        <Button
                          type="button"
                          variant="ghost"
                          size="icon"
                          className="text-primary hover:text-primary"
                          disabled={
                            restore.isPending &&
                            restore.variables === session.id
                          }
                          onClick={() => restore.mutate(session.id)}
                          aria-label="Restore chat"
                          title="Restore chat"
                        >
                          <RotateCcw className="size-4" />
                        </Button>
                      ) : null}
                      {session.status === "Abandoned" ||
                      session.status === "Published" ? (
                        <Button
                          type="button"
                          variant="ghost"
                          size="icon"
                          className="text-destructive hover:text-destructive"
                          disabled={
                            remove.isPending && remove.variables === session.id
                          }
                          onClick={() => setDeleteTarget(session)}
                          aria-label="Delete permanently"
                          title="Delete permanently"
                        >
                          <Trash2 className="size-4" />
                        </Button>
                      ) : null}
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </DataTableShell>

      <Sheet open={panelOpen} onOpenChange={open => {
        setPanelOpen(open)
        if (!open && searchParams.has("new")) setSearchParams({}, { replace: true })
      }}>
        <SheetContent>
          <SheetHeader>
            <SheetTitle>New authoring chat</SheetTitle>
            <SheetDescription>
              Optional title, then pick an available assistant model.
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

            {providersQuery.isPending ? (
              <div className="space-y-2">
                <Label>Assistant</Label>
                <div className="flex items-center gap-2 text-sm text-muted-foreground">
                  <Loader2 className="size-4 animate-spin" />
                  Loading providers…
                </div>
              </div>
            ) : providersQuery.isError ? (
              <div className="space-y-2">
                <Label>Assistant</Label>
                <p className="text-sm text-destructive">
                  Could not load assistant providers.
                </p>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => void providersQuery.refetch()}
                >
                  Retry
                </Button>
              </div>
            ) : providers.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                No assistant providers are configured.
              </p>
            ) : (
              <>
                <div className="space-y-2">
                  <Label htmlFor="session-provider">Provider</Label>
                  <Select
                    value={selection?.provider ?? undefined}
                    onValueChange={handleProviderChange}
                  >
                    <SelectTrigger id="session-provider" className="w-full">
                      <SelectValue placeholder="Select a provider" />
                    </SelectTrigger>
                    <SelectContent>
                      {providers.map((provider) => (
                        <SelectItem
                          key={provider.provider}
                          value={provider.provider}
                          disabled={!provider.isAvailable}
                        >
                          <ProviderIcon
                            iconKey={provider.iconKey}
                            className="size-4"
                          />
                          {provider.displayName}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="session-model">Model</Label>
                  <Select
                    value={
                      activeProvider && selection?.model
                        ? selection.model
                        : undefined
                    }
                    onValueChange={setSelectedModel}
                    disabled={!activeProvider?.isAvailable}
                  >
                    <SelectTrigger id="session-model" className="w-full">
                      <SelectValue placeholder="Select a model" />
                    </SelectTrigger>
                    <SelectContent>
                      {(activeProvider?.models ?? []).map((model) => (
                        <SelectItem
                          key={model.model}
                          value={model.model}
                          disabled={
                            !model.isAvailable || !model.supportsToolCalling
                          }
                        >
                          {model.displayName}
                          {model.isDefault ? " (default)" : ""}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                  <p className="text-xs text-muted-foreground">
                    Only models with tool calling can author presets.
                  </p>
                </div>

                {unavailableProviders.length > 0 ? (
                  <div className="space-y-1 rounded-md border border-border bg-muted/40 p-3">
                    <p className="text-xs font-medium tracking-widest text-muted-foreground uppercase">
                      Unavailable providers
                    </p>
                    <ul className="space-y-1 text-xs text-muted-foreground">
                      {unavailableProviders.map((provider) => (
                        <li key={provider.provider}>
                          <span className="text-foreground">
                            {provider.displayName}
                          </span>
                          {": "}
                          {unavailableReasonLabel(provider.unavailableReason)}
                        </li>
                      ))}
                    </ul>
                  </div>
                ) : null}
              </>
            )}
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
              disabled={create.isPending || !canCreate}
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
        open={abandonTarget !== null}
        onOpenChange={(open) => {
          if (!open) setAbandonTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Abandon this chat?</AlertDialogTitle>
            <AlertDialogDescription>
              The chat will be marked abandoned and can no longer be edited or
              published. You can restore it later.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={abandon.isPending}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              disabled={abandon.isPending}
              onClick={() => {
                if (abandonTarget) abandon.mutate(abandonTarget.id);
              }}
            >
              Abandon chat
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog
        open={deleteTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete chat permanently?</AlertDialogTitle>
            <AlertDialogDescription>
              This permanently deletes the chat, its message history, and its
              draft. They cannot be recovered. If this chat published a preset,
              that published preset is not deleted.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={remove.isPending}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              disabled={remove.isPending}
              onClick={() => {
                if (deleteTarget) remove.mutate(deleteTarget.id);
              }}
            >
              Delete permanently
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
