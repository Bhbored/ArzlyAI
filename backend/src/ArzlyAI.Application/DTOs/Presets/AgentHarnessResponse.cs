namespace ArzlyAI.Application.DTOs.Presets;
public sealed record AgentHarnessResponse(
    bool PlanningEnabled,
    bool TodoTrackingEnabled,
    bool ContextCompactionEnabled,
    bool RequiresToolApproval,
    int MaximumIterations);
