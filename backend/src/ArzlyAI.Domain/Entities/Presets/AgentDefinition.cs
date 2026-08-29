using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Entities.Common;
using ArzlyAI.Domain.Enums;
namespace ArzlyAI.Domain.Presets;
public sealed class AgentDefinition : Base
{
    public Guid PresetId { get; init; }
    public Guid ModelId { get; init; }
    public required string Key { get; init; }
    public required string Name { get; init; }
    public required string Instructions { get; init; }
    public AgentRuntimeType RuntimeType { get; init; }
    public double DefaultTemperature { get; init; }
    public double MinimumTemperature { get; init; }
    public double MaximumTemperature { get; init; }
    public bool AllowModelOverride { get; init; }
    public bool AllowTemperatureOverride { get; init; }
    public PresetDefinition Preset { get; init; } = null!;
    public ModelDefinition Model { get; init; } = null!;
    public AgentHarnessDefinition Harness { get; set; } = null!;
}
