namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record WorkflowNodeChangedEvent(
    Guid RunId, Guid NodeId, string NodeKey, string Status, bool IsRunning,
    string Message, DateTimeOffset OccurredAtUtc);
