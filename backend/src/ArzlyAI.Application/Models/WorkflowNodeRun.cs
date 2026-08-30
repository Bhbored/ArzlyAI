using ArzlyAI.Domain.Enums;
namespace ArzlyAI.Application.Models;
public sealed class WorkflowNodeRun
{
    public Guid NodeId { get; init; }
    public required string NodeKey { get; init; }
    public required string DisplayName { get; init; }
    public WorkflowNodeType Type { get; init; }
    public WorkflowNodeStatus Status { get; set; }
    public string? Output { get; set; }
    public string? Error { get; set; }
    public string? EffectiveProvider { get; set; }
    public string? EffectiveModel { get; set; }
    public double? EffectiveTemperature { get; set; }
}
