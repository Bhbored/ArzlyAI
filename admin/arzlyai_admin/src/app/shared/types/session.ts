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
}

export interface AuthoringTurnResponse {
  session: AuthoringSession
  assistantMessage: string
}

export interface PublishPresetResponse {
  presetId: string
}
