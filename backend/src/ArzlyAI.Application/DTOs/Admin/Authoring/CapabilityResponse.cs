namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record CapabilityResponse(
    string Key,
    string Kind,
    string DisplayName,
    string Description,
    string? ConnectorKey,
    string InputSchemaJson,
    string OutputSchemaJson,
    string RequiredOAuthScopesJson,
    string RequiredApisJson,
    string DocumentationLinksJson,
    string RiskLevel,
    bool SupportsBackgroundExecution);
