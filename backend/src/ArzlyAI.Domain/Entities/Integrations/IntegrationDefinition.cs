using ArzlyAI.Domain.Entities.Common;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Domain.Catalog;
public sealed class IntegrationDefinition : Base
{
    public Guid? ConnectorId { get; set; }
    public required string Key { get; init; }
    public required string DisplayName { get; init; }
    public required string Description { get; init; }
    public required string CredentialSchemaJson { get; set; }
    public bool IsEnabled { get; init; }
    public string InputSchemaJson { get; set; } = "{}";
    public string OutputSchemaJson { get; set; } = "{}";
    public string RequiredOAuthScopesJson { get; set; } = "[]";
    public string RequiredApisJson { get; set; } = "[]";
    public string DocumentationLinksJson { get; set; } = "[]";
    public IntegrationRiskLevel RiskLevel { get; set; }
    public bool SupportsBackgroundExecution { get; set; }
    public ConnectorDefinition? Connector { get; set; }
}
