using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Presets;
public sealed class PresetDefinition : Base
{
    public required string Key { get; init; }
    public required string Name { get; init; }
    public required string Description { get; init; }
    public int Version { get; init; }
    public bool IsPublished { get; init; }
    public string? InputSchemaJson { get; init; }
    public string? ResultContractKey { get; init; }
    public int? ResultContractVersion { get; init; }
    public ICollection<AgentDefinition> Agents { get; init; } = [];
    public WorkflowDefinition Workflow { get; set; } = null!;
    public ICollection<PresetIntegration> Integrations { get; init; } = [];
}
