using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Catalog;
public sealed class IntegrationDefinition : Base
{
    public required string Key { get; init; }
    public required string DisplayName { get; init; }
    public required string Description { get; init; }
    public required string CredentialSchemaJson { get; init; }
    public bool IsEnabled { get; init; }
}
