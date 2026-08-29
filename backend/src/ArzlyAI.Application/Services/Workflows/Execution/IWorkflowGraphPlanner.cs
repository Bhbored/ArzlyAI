using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public interface IWorkflowGraphPlanner
{
    IReadOnlyList<WorkflowStepDefinition> Plan(WorkflowDefinition workflow);
}
