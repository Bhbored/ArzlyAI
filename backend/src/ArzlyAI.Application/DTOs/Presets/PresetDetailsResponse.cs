namespace ArzlyAI.Application.DTOs.Presets;
public sealed record PresetDetailsResponse(
    Guid Id, string Key, string Name, string Description, int Version,
    IReadOnlyList<AgentResponse> Agents,
    WorkflowGraphResponse Workflow,
    IReadOnlyList<IntegrationRequirementResponse> Integrations);
