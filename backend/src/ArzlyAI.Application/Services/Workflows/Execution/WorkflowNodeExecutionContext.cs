using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed record WorkflowNodeExecutionContext(
    PresetDefinition Preset,
    WorkflowStepDefinition Step,
    WorkflowRun Run,
    IReadOnlyDictionary<string, string> Inputs,
    IReadOnlyDictionary<string, string> Credentials,
    AgentOverrideRequest? AgentOverride);
