using ArzlyAI.Application.Models;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public interface IWorkflowInputMapper
{
    IReadOnlyDictionary<string, string> Map(
        WorkflowStepDefinition step,
        IReadOnlyList<WorkflowStepDefinition> plan,
        WorkflowRun run);
}
