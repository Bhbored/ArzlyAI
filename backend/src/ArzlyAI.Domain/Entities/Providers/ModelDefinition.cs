using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Catalog;
public sealed class ModelDefinition : Base
{
    public Guid ProviderId { get; init; }
    public required string Key { get; init; }
    public required string DisplayName { get; init; }
    public bool IsDefault { get; init; }
    public ProviderDefinition Provider { get; init; } = null!;
}
