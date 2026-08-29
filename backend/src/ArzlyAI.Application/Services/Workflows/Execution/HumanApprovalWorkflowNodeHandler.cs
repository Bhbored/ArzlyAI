using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed class HumanApprovalWorkflowNodeHandler : IWorkflowNodeHandler
{
    public WorkflowNodeType NodeType => WorkflowNodeType.HumanApproval;
    public bool StartsRunning => false;

    public string RunningMessage(WorkflowStepDefinition step) => string.Empty;

    public Task<WorkflowNodeExecutionResult> ExecuteAsync(
        WorkflowNodeExecutionContext context,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("HumanApprovalWorkflowNodeHandler.Execute");
        var content = ResolveContent(context.Inputs);
        context.Run.OriginalContent = content;
        context.Run.CurrentContent = content;
        context.Run.PendingApprovalNodeId = context.Step.Id;

        return Task.FromResult(new WorkflowNodeExecutionResult(
            null,
            WorkflowNodeStatus.WaitingForApproval,
            "Review, edit, accept, or reject the generated content.",
            PausesWorkflow: true));
    }

    private static string ResolveContent(IReadOnlyDictionary<string, string> inputs)
    {
        if (inputs.TryGetValue("content", out var content) && !string.IsNullOrWhiteSpace(content))
            return content;
        if (inputs.Count == 1 && !string.IsNullOrWhiteSpace(inputs.Single().Value))
            return inputs.Single().Value;
        throw new ArgumentException("A human approval node requires one mapped content value.");
    }
}
