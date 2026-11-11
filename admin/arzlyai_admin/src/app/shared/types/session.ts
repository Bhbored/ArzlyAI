import type { PresetDraft } from "./draft"
import type { ValidationResult } from "./validation"
import type { AssistantModelSelection } from "./assistantModel"

export interface AuthoringMessage {
  id: string
  sequence: number
  role: string
  content: string
  toolName: string | null
  createdAtUtc: string
}

export interface AuthoringSession {
  id: string
  title: string | null
  status: string
  revision: number
  assistantModel: AssistantModelSelection
  draft: PresetDraft | null
  validation: ValidationResult
  publishedPresetId: string | null
  messages: AuthoringMessage[]
  createdAtUtc: string
  updatedAtUtc: string
  draftRevision: number
  validatedDraftRevision: number | null
  turn: { id: string; status: "Running" | "Completed" | "Failed"; startedAtUtc: string | null; error: string | null } | null
  publishReadiness: { canPublish: boolean; blockers: string[] }
}

export type AuthoringSessionSummary = Pick<AuthoringSession, "id" | "title" | "status" | "revision" | "assistantModel" | "updatedAtUtc">

export interface AuthoringPreview {
  draftRevision: number
  validation: ValidationResult
  nodes: { key: string; name: string; type: string; inputs: { input: string; source: string; status: string; value: unknown }[] }[]
}

export interface RuntimeModel { provider: string; model: string; displayName: string }

export interface AuthoringTurnResponse {
  session: AuthoringSession
  assistantMessage: string
}

export interface PublishPresetResponse {
  presetId: string
}
