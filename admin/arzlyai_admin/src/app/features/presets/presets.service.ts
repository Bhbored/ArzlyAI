import { queryOptions } from "@tanstack/react-query"
import { apiFetch, STALE_TIME } from "../../shared/api/http"
import type {
  AdminPresetDetails,
  AdminPresetSummary,
  AuthoringSession,
} from "../../shared/types"

export const presetKeys = {
  all: ["admin-presets"] as const,
  list: () => [...presetKeys.all, "list"] as const,
  detail: (key: string, version: number) =>
    [...presetKeys.all, "detail", key, version] as const,
}

export async function fetchPresets() {
  return apiFetch<AdminPresetSummary[]>("/api/v1/admin/presets")
}

export async function fetchPresetVersion(key: string, version: number) {
  return apiFetch<AdminPresetDetails>(
    `/api/v1/admin/presets/${encodeURIComponent(key)}/versions/${version}`,
  )
}

export async function clonePresetToDraft(key: string, version: number) {
  return apiFetch<AuthoringSession>(
    `/api/v1/admin/presets/${encodeURIComponent(key)}/versions/${version}/draft`,
    { method: "POST" },
  )
}

export async function archivePresetVersion(key: string, version: number) {
  return apiFetch<void>(
    `/api/v1/admin/presets/${encodeURIComponent(key)}/versions/${version}/archive`,
    { method: "POST" },
  )
}

export const presetQueries = {
  list: () =>
    queryOptions({
      queryKey: presetKeys.list(),
      queryFn: fetchPresets,
      staleTime: STALE_TIME,
    }),
  detail: (key: string, version: number) =>
    queryOptions({
      queryKey: presetKeys.detail(key, version),
      queryFn: () => fetchPresetVersion(key, version),
      staleTime: STALE_TIME,
    }),
}
