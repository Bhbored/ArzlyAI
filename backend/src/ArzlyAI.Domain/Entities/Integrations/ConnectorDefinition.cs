using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Catalog;

public sealed class ConnectorDefinition : Base
{
    public required string Key { get; init; }
    public required string DisplayName { get; init; }
    public required string Description { get; init; }
    public required string AuthenticationType { get; init; }
    public bool IsEnabled { get; init; }
    public ICollection<IntegrationDefinition> Integrations { get; init; } = [];
}
