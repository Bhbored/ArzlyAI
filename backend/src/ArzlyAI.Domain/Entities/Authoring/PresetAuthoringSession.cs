using ArzlyAI.Domain.Entities.Common;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Domain.Authoring;

public sealed class PresetAuthoringSession : Base
{
    public Guid CreatedByAdminId { get; init; }
    public string? Title { get; set; }
    public string? AssistantProvider { get; set; }
    public string? AssistantModel { get; set; }
    public AuthoringSessionStatus Status { get; set; }
    public string? DraftJson { get; set; }
    public string ValidationJson { get; set; } = "{\"isValid\":false,\"errors\":[]}";
    public int Revision { get; set; }
    public Guid? PublishedPresetId { get; set; }
    public ICollection<PresetAuthoringMessage> Messages { get; init; } = [];
}
