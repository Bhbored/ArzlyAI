using ArzlyAI.Domain.Catalog;
namespace ArzlyAI.Domain.Presets;
public sealed class PresetIntegration
{
    public Guid PresetId { get; init; }
    public Guid IntegrationId { get; init; }
    public PresetDefinition Preset { get; init; } = null!;
    public IntegrationDefinition Integration { get; init; } = null!;
}
