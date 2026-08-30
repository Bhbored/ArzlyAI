namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record WorkflowNodeRunResponse(
    Guid NodeId,
    string NodeKey,
    string DisplayName,
    string Type,
    string Status,
    bool IsRunning,
    string? Output,
    string? Error,
    string? EffectiveProvider,
    string? EffectiveModel,
    double? EffectiveTemperature);
