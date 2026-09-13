namespace ArzlyAI.Application.DTOs.Presets;
public sealed record PresetDetailsResponse(
    Guid Id, string Key, string Name, string Description, int Version,
    IReadOnlyList<AgentResponse> Agents,
    WorkflowGraphResponse Workflow,
    IReadOnlyList<IntegrationRequirementResponse> Integrations,
    string? InputSchemaJson,
    ResultContractResponse? ResultContract,
    string? Subtitle = null,
    string? DetailedDescription = null,
    BackgroundExecutionPolicyResponse? BackgroundExecution = null);
