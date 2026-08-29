using ArzlyAI.Application.Integrations;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed class IntegrationWorkflowNodeHandler(
    IEnumerable<IIntegrationHandler> integrationHandlers) : IWorkflowNodeHandler
{
    public WorkflowNodeType NodeType => WorkflowNodeType.Integration;
    public bool StartsRunning => true;

    public string RunningMessage(WorkflowStepDefinition step) => $"{step.DisplayName} is running.";

    public async Task<WorkflowNodeExecutionResult> ExecuteAsync(
        WorkflowNodeExecutionContext context,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("IntegrationWorkflowNodeHandler.Execute");
        var handler = integrationHandlers.SingleOrDefault(candidate => candidate.Key == context.Step.ReferenceKey)
            ?? throw new InvalidOperationException(
                $"No integration handler is installed for '{context.Step.ReferenceKey}'.");
        var output = await handler.ExecuteAsync(context.Inputs, context.Credentials, cancellationToken);
        return new WorkflowNodeExecutionResult(
            output,
            WorkflowNodeStatus.Completed,
            $"{context.Step.DisplayName} completed.");
    }
}
