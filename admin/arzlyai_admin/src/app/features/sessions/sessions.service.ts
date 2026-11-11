import { queryOptions } from "@tanstack/react-query";
import { apiFetch, STALE_TIME } from "../../shared/api/http";
import type {
  AuthoringModelOption,
  AuthoringProvider,
  AuthoringSession,
  AuthoringSessionSummary,
  AuthoringPreview,
  RuntimeModel,
  PresetDraft,
  AuthoringTurnResponse,
  PublishPresetResponse,
} from "../../shared/types";

export const sessionKeys = {
  all: ["authoring-sessions"] as const,
  list: () => [...sessionKeys.all, "list"] as const,
  detail: (id: string) => [...sessionKeys.all, "detail", id] as const,
  models: () => [...sessionKeys.all, "assistant-models"] as const,
  providers: () => [...sessionKeys.all, "assistant-providers"] as const,
};

export async function fetchSessions() {
  return apiFetch<AuthoringSessionSummary[]>("/api/v1/admin/authoring/session-summaries");
}

export async function fetchSession(id: string) {
  return apiFetch<AuthoringSession>(`/api/v1/admin/authoring/sessions/${id}`);
}

export async function fetchAssistantModels() {
  return apiFetch<AuthoringModelOption[]>(
    "/api/v1/admin/authoring/assistant-models",
  );
}

export async function fetchAssistantProviders() {
  return apiFetch<AuthoringProvider[]>(
    "/api/v1/admin/authoring/assistant-providers",
  );
}

export async function createSession(
  title?: string,
  provider?: string | null,
  model?: string | null,
  useVisualBuilder = false,
) {
  return apiFetch<AuthoringSession>("/api/v1/admin/authoring/sessions", {
    method: "POST",
    body: JSON.stringify({
      title: title?.trim() || null,
      provider: provider ?? null,
      model: model ?? null,
      useVisualBuilder,
    }),
  });
}

export async function setAssistantModel(
  sessionId: string,
  provider: string,
  model: string,
  expectedRevision: number,
) {
  return apiFetch<AuthoringSession>(
    `/api/v1/admin/authoring/sessions/${sessionId}/assistant-model`,
    {
      method: "PUT",
      body: JSON.stringify({ provider, model, expectedRevision }),
    },
  );
}

export async function sendMessage(
  sessionId: string,
  content: string,
  expectedRevision: number,
  clientRequestId?: string,
) {
  return apiFetch<AuthoringTurnResponse>(
    `/api/v1/admin/authoring/sessions/${sessionId}/messages`,
    {
      method: "POST",
      body: JSON.stringify({ content, expectedRevision, clientRequestId }),
    },
  );
}

export async function validateSession(sessionId: string) {
  return apiFetch<AuthoringSession>(
    `/api/v1/admin/authoring/sessions/${sessionId}/validate`,
    { method: "POST" },
  );
}

export async function publishSession(
  sessionId: string,
  expectedRevision: number,
) {
  return apiFetch<PublishPresetResponse>(
    `/api/v1/admin/authoring/sessions/${sessionId}/publish`,
    {
      method: "POST",
      body: JSON.stringify({ expectedRevision }),
    },
  );
}

export async function abandonSession(sessionId: string) {
  return apiFetch<AuthoringSession>(
    `/api/v1/admin/authoring/sessions/${sessionId}/abandon`,
    { method: "POST" },
  );
}

export async function restoreSession(sessionId: string) {
  return apiFetch<AuthoringSession>(
    `/api/v1/admin/authoring/sessions/${sessionId}/restore`,
    { method: "POST" },
  );
}

export async function deleteSessionPermanently(sessionId: string) {
  return apiFetch<void>(`/api/v1/admin/authoring/sessions/${sessionId}/permanent`, {
    method: "DELETE",
  });
}

export const sessionQueries = {
  list: () =>
    queryOptions({
      queryKey: sessionKeys.list(),
      queryFn: fetchSessions,
      staleTime: STALE_TIME,
    }),
  detail: (id: string) =>
    queryOptions({
      queryKey: sessionKeys.detail(id),
      queryFn: () => fetchSession(id),
      staleTime: 30_000,
    }),
  models: () =>
    queryOptions({
      queryKey: sessionKeys.models(),
      queryFn: fetchAssistantModels,
      staleTime: STALE_TIME,
    }),
  providers: () =>
    queryOptions({
      queryKey: sessionKeys.providers(),
      queryFn: fetchAssistantProviders,
      staleTime: STALE_TIME,
    }),
};

export function saveDraft(id: string, expectedRevision: number, draft: PresetDraft) {
  return apiFetch<AuthoringSession>(`/api/v1/admin/authoring/sessions/${id}/draft`, {
    method: "PUT", body: JSON.stringify({ expectedRevision, draft }),
  });
}

export function previewDraft(id: string, expectedRevision: number, sampleInputs: unknown) {
  return apiFetch<AuthoringPreview>(`/api/v1/admin/authoring/sessions/${id}/preview`, {
    method: "POST", body: JSON.stringify({ expectedRevision, sampleInputs }),
  });
}

export function fetchRuntimeModels() {
  return apiFetch<RuntimeModel[]>("/api/v1/admin/authoring/runtime-models");
}
