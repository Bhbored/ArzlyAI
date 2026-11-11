using ArzlyAI.Domain.Entities.Common;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Domain.Authoring;

public sealed class PresetAuthoringMessage : Base
{
    public Guid SessionId { get; init; }
    public int Sequence { get; init; }
    public Guid? ClientRequestId { get; init; }
    public Guid? TurnId { get; init; }
    public AuthoringMessageRole Role { get; init; }
    public required string Content { get; init; }
    public string? ToolName { get; init; }
    public string? ToolPayloadJson { get; init; }
    public PresetAuthoringSession Session { get; init; } = null!;
}
