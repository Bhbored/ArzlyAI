using ArzlyAI.Application.Models;
namespace ArzlyAI.Application.Repositories.Workflows;
public interface IWorkflowRunRepository
{
    Task AddAsync(WorkflowRun run, CancellationToken cancellationToken);
    Task<WorkflowRun?> GetAsync(Guid runId, CancellationToken cancellationToken);
    Task UpdateAsync(WorkflowRun run, CancellationToken cancellationToken);
}
