using ArzlyAI.Domain.Entities.Common;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Domain.Presets;
public sealed class PresetDefinition : Base
{
    public required string Key { get; init; }
    public required string Name { get; init; }
    public required string Description { get; init; }
    public string? Subtitle { get; init; }
    public string? DetailedDescription { get; init; }
    public int Version { get; init; }
    public PresetPublicationStatus Status { get; set; }
    public DateTimeOffset? PublishedAtUtc { get; set; }
    public DateTimeOffset? ArchivedAtUtc { get; set; }
    public Guid? PublishedByAdminId { get; init; }
    public Guid? SupersedesPresetId { get; init; }
    public string? InputSchemaJson { get; init; }
    public string? ResultContractKey { get; init; }
    public int? ResultContractVersion { get; init; }
    public BackgroundExecutionMode BackgroundExecutionMode { get; init; }
    public string? BackgroundExecutionRationale { get; init; }
    public string AllowedTriggerTypesJson { get; init; } = "[]";
    public ICollection<AgentDefinition> Agents { get; init; } = [];
    public WorkflowDefinition Workflow { get; set; } = null!;
    public ICollection<PresetIntegration> Integrations { get; init; } = [];
    public ICollection<PresetAdminNote> AdminNotes { get; init; } = [];
}
