using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public interface IWorkflowNodeHandler
{
    WorkflowNodeType NodeType { get; }
    bool StartsRunning { get; }
    string RunningMessage(WorkflowStepDefinition step);
    Task<WorkflowNodeExecutionResult> ExecuteAsync(
        WorkflowNodeExecutionContext context,
        CancellationToken cancellationToken);
}
