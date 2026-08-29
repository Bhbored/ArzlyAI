namespace ArzlyAI.Application.DTOs.Presets;
public sealed record WorkflowGraphResponse(
    string Key,
    IReadOnlyList<WorkflowNodeResponse> Nodes,
    IReadOnlyList<WorkflowConnectionResponse> Connections);
