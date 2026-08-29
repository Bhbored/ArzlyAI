using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Presets;
public sealed class WorkflowConnectionDefinition : Base
{
    public Guid WorkflowId { get; init; }
    public Guid SourceStepId { get; init; }
    public Guid TargetStepId { get; init; }
    public WorkflowDefinition Workflow { get; init; } = null!;
}
