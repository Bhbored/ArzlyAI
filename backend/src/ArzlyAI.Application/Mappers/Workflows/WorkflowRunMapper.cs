using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Mappers.Workflows;

public sealed class WorkflowRunMapper : IWorkflowRunMapper
{
    public WorkflowRunResponse ToResponse(WorkflowRun run) => new(
        run.Id,
        run.PresetKey,
        run.Status.ToString(),
        run.Nodes.Select(node => new WorkflowNodeRunResponse(
            node.NodeId,
            node.NodeKey,
            node.DisplayName,
            node.Type.ToString(),
            node.Status.ToString(),
            node.Status == WorkflowNodeStatus.Running,
            node.Output,
            node.Error)).ToList(),
        run.OriginalContent is null
            ? null
            : new ApprovalSnapshotResponse(
                run.OriginalContent,
                run.CurrentContent ?? run.OriginalContent,
                run.CurrentContent != run.OriginalContent),
        run.FinalResponse);
}
