export interface Capability {
  key: string
  kind: string
  displayName: string
  description: string
  connectorKey: string | null
  inputSchemaJson: string
  outputSchemaJson: string
  requiredOAuthScopesJson: string
  requiredApisJson: string
  documentationLinksJson: string
  riskLevel: string
  supportsBackgroundExecution: boolean
}
