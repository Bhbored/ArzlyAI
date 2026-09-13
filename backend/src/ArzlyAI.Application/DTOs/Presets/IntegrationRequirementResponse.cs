namespace ArzlyAI.Application.DTOs.Presets;
public sealed record IntegrationRequirementResponse(
    string Key, string Name, string Description, string CredentialSchemaJson,
    string? ConnectorKey = null,
    string RequiredOAuthScopesJson = "[]",
    string RequiredApisJson = "[]",
    bool SupportsBackgroundExecution = false);
