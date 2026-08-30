using ArzlyAI.Application.Services.Workflows.Operations;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed class OperationWorkflowNodeHandler(
    IEnumerable<IWorkflowOperation> operations) : IWorkflowNodeHandler
{
    public WorkflowNodeType NodeType => WorkflowNodeType.Operation;
    public bool StartsRunning => true;

    public string RunningMessage(WorkflowStepDefinition step) =>
        $"{step.DisplayName} is running.";

    public async Task<WorkflowNodeExecutionResult> ExecuteAsync(
        WorkflowNodeExecutionContext context,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("OperationWorkflowNodeHandler.Execute");
        var handler = operations.SingleOrDefault(item => item.Key == context.Step.ReferenceKey)
            ?? throw new InvalidOperationException(
                $"No workflow operation is installed for '{context.Step.ReferenceKey}'.");
        var output = await handler.ExecuteAsync(context.Inputs, cancellationToken);
        return new WorkflowNodeExecutionResult(
            output, WorkflowNodeStatus.Completed, $"{context.Step.DisplayName} completed.");
    }
}
