import { queryOptions } from "@tanstack/react-query"
import { apiFetch, STALE_TIME } from "../../shared/api/http"
import type {
  AuthoringModelOption,
  AuthoringSession,
  AuthoringTurnResponse,
  PublishPresetResponse,
} from "../../shared/types"

export const sessionKeys = {
  all: ["authoring-sessions"] as const,
  list: () => [...sessionKeys.all, "list"] as const,
  detail: (id: string) => [...sessionKeys.all, "detail", id] as const,
  models: () => [...sessionKeys.all, "assistant-models"] as const,
}

export async function fetchSessions() {
  return apiFetch<AuthoringSession[]>("/api/v1/admin/authoring/sessions")
}

export async function fetchSession(id: string) {
  return apiFetch<AuthoringSession>(`/api/v1/admin/authoring/sessions/${id}`)
}

export async function fetchAssistantModels() {
  return apiFetch<AuthoringModelOption[]>(
    "/api/v1/admin/authoring/assistant-models",
  )
}

export async function createSession(title?: string) {
  return apiFetch<AuthoringSession>("/api/v1/admin/authoring/sessions", {
    method: "POST",
    body: JSON.stringify({ title: title?.trim() || null }),
  })
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
  )
}

export async function sendMessage(
  sessionId: string,
  content: string,
  expectedRevision: number,
) {
  return apiFetch<AuthoringTurnResponse>(
    `/api/v1/admin/authoring/sessions/${sessionId}/messages`,
    {
      method: "POST",
      body: JSON.stringify({ content, expectedRevision }),
    },
  )
}

export async function validateSession(sessionId: string) {
  return apiFetch<AuthoringSession>(
    `/api/v1/admin/authoring/sessions/${sessionId}/validate`,
    { method: "POST" },
  )
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
  )
}

export async function abandonSession(sessionId: string) {
  return apiFetch<void>(`/api/v1/admin/authoring/sessions/${sessionId}`, {
    method: "DELETE",
  })
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
}
