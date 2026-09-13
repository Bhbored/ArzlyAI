import { queryOptions } from "@tanstack/react-query"
import { apiFetch, STALE_TIME } from "../../shared/api/http"
import type { Capability } from "../../shared/types"

export const capabilityKeys = {
  all: ["capabilities"] as const,
  list: () => [...capabilityKeys.all, "list"] as const,
}

export async function fetchCapabilities() {
  return apiFetch<Capability[]>("/api/v1/admin/authoring/capabilities")
}

export const capabilityQueries = {
  list: () =>
    queryOptions({
      queryKey: capabilityKeys.list(),
      queryFn: fetchCapabilities,
      staleTime: STALE_TIME,
    }),
}
