using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed record WorkflowNodeExecutionResult(
    string? Output,
    WorkflowNodeStatus Status,
    string Message,
    bool PausesWorkflow = false,
    string? EffectiveProvider = null,
    string? EffectiveModel = null,
    double? EffectiveTemperature = null);
