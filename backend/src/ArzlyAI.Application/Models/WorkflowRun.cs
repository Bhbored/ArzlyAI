using ArzlyAI.Application.DTOs.Workflows;

using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Models;

public sealed class WorkflowRun
{
    public Guid Id { get; init; }
    public required string PresetKey { get; init; }
    public WorkflowRunStatus Status { get; set; }
    public DateTimeOffset ExpiresAtUtc { get; set; }
    public List<WorkflowNodeRun> Nodes { get; init; } = [];
    public Dictionary<string, string> Inputs { get; init; } = new(StringComparer.Ordinal);
    public List<AgentOverrideRequest> AgentOverrides { get; init; } = [];
    public Dictionary<Guid, string> ApprovedOutputs { get; init; } = [];
    public Dictionary<Guid, string> RegenerationFeedback { get; init; } = [];
    public Guid? PendingApprovalNodeId { get; set; }
    public string? OriginalContent { get; set; }
    public string? CurrentContent { get; set; }
    public string? FinalResponse { get; set; }
}
