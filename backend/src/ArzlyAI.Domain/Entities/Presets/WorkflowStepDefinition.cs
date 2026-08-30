using ArzlyAI.Domain.Entities.Common;
using ArzlyAI.Domain.Enums;
namespace ArzlyAI.Domain.Presets;
public sealed class WorkflowStepDefinition : Base
{
    public Guid WorkflowId { get; init; }
    public int Position { get; init; }
    public WorkflowNodeType Type { get; init; }
    public required string ReferenceKey { get; init; }
    public required string DisplayName { get; init; }
    public required string InputMappingJson { get; init; }
    public bool RequiresHumanApproval { get; init; }
    public string? ConfigurationJson { get; init; }
    public string? ResultContractKey { get; init; }
    public int? ResultContractVersion { get; init; }
    public WorkflowDefinition Workflow { get; init; } = null!;
}
