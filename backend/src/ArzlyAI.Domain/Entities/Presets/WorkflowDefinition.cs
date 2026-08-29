using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Presets;
public sealed class WorkflowDefinition : Base
{
    public Guid PresetId { get; init; }
    public required string Key { get; init; }
    public PresetDefinition Preset { get; init; } = null!;
    public ICollection<WorkflowStepDefinition> Steps { get; init; } = [];
    public ICollection<WorkflowConnectionDefinition> Connections { get; init; } = [];
}
