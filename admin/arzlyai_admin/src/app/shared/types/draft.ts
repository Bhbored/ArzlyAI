export interface BackgroundExecutionPolicy {
  mode: number | string
  rationale: string
  allowedTriggerTypes: string[]
}

export interface PresetDraftHarness {
  planningEnabled: boolean
  todoTrackingEnabled: boolean
  contextCompactionEnabled: boolean
  requireToolApproval: boolean
  maxIterations: number
  webSearchEnabled: boolean
}

export interface PresetDraftAgent {
  key: string
  name: string
  instructions: string
  runtimeType: number | string
  providerKey: string
  modelKey: string
  defaultTemperature: number
  minimumTemperature: number
  maximumTemperature: number
  allowModelOverride: boolean
  allowTemperatureOverride: boolean
  outputSchemaJson: string | null
  harness: PresetDraftHarness
}

export interface PresetDraftNode {
  key: string
  displayName: string
  type: number | string
  referenceKey: string
  position: number
  inputMappingJson: string
  requiresHumanApproval: boolean
  configurationJson: string | null
  resultContractKey: string | null
  resultContractVersion: number | null
}

export interface PresetDraftConnection {
  sourceNodeKey: string
  targetNodeKey: string
}

export interface PresetDraftWorkflow {
  key: string
  nodes: PresetDraftNode[]
  connections: PresetDraftConnection[]
}

export interface PresetDraftAdminNote {
  title: string
  description: string
  severity: number | string
  links: string[]
}

export interface PresetDraft {
  key: string
  title: string
  subtitle: string
  description: string
  detailedDescription: string
  inputSchemaJson: string
  resultContractKey: string | null
  resultContractVersion: number | null
  backgroundExecution: BackgroundExecutionPolicy
  agents: PresetDraftAgent[]
  workflow: PresetDraftWorkflow
  adminNotes: PresetDraftAdminNote[]
}
