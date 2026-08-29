using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Catalog;
public sealed class ProviderDefinition : Base
{
    public required string Key { get; init; }
    public required string DisplayName { get; init; }
    public ICollection<ModelDefinition> Models { get; init; } = [];
}
