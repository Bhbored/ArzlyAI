using ArzlyAI.Domain.Entities.Common;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Domain.Presets;

public sealed class PresetAdminNote : Base
{
    public Guid PresetId { get; init; }
    public required string Title { get; init; }
    public required string Description { get; init; }
    public AdminNoteSeverity Severity { get; init; }
    public string LinksJson { get; init; } = "[]";
    public int DisplayOrder { get; init; }
    public PresetDefinition Preset { get; init; } = null!;
}
