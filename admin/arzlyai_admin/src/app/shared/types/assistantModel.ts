export interface AssistantModelSelection {
  provider: string
  model: string
}

export interface AuthoringModelOption {
  provider: string
  model: string
  displayName: string
  supportsTemperature: boolean
  supportsWebSearch: boolean
  isDefault: boolean
}
