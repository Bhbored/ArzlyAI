export interface AssistantModelSelection {
  provider: string
  model: string
}

export interface AuthoringModelOption {
  provider: string
  model: string
  displayName: string
  supportsToolCalling: boolean
  supportsTemperature: boolean
  supportsWebSearch: boolean
  isAvailable: boolean
  isDefault: boolean
}

export interface AuthoringProvider {
  provider: string
  displayName: string
  iconKey: string
  hasApiKey: boolean
  isEnabled: boolean
  isAvailable: boolean
  unavailableReason: string | null
  models: AuthoringModelOption[]
}
