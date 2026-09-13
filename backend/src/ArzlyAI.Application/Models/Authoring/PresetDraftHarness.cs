namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftHarness(
    bool PlanningEnabled,
    bool TodoTrackingEnabled,
    bool ContextCompactionEnabled,
    bool RequireToolApproval,
    int MaxIterations,
    bool WebSearchEnabled);
