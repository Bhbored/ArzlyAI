export interface AdminNote {
  title: string
  description: string
  severity: string
  linksJson: string
  displayOrder: number
}

export interface AdminPresetSummary {
  id: string
  key: string
  name: string
  version: number
  status: string
  publishedAtUtc: string | null
}

export interface PresetAgentSummary {
  key?: string
  name?: string
  [key: string]: unknown
}

export interface PresetDetails {
  id: string
  key: string
  name: string
  description: string
  version: number
  agents: PresetAgentSummary[]
  workflow: {
    key?: string
    nodes?: unknown[]
    connections?: unknown[]
    [key: string]: unknown
  }
  integrations: Array<{ key?: string; name?: string; [key: string]: unknown }>
  inputSchemaJson: string | null
  resultContract: { key?: string; version?: number; [key: string]: unknown } | null
  subtitle: string | null
  detailedDescription: string | null
  backgroundExecution: {
    mode?: string
    rationale?: string
    allowedTriggerTypes?: string[]
    [key: string]: unknown
  } | null
}

export interface AdminPresetDetails {
  preset: PresetDetails
  status: string
  publishedByAdminId: string | null
  supersedesPresetId: string | null
  adminNotes: AdminNote[]
}
