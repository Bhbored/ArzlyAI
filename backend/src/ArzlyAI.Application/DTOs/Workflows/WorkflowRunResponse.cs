namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record WorkflowRunResponse(
    Guid RunId,
    string PresetKey,
    string Status,
    IReadOnlyList<WorkflowNodeRunResponse> Nodes,
    ApprovalSnapshotResponse? Approval,
    string? FinalResponse);
