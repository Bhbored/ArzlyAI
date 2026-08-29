using System.Collections.Concurrent;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Repositories.Workflows;
using Microsoft.Extensions.Logging;
using SerilogTimings;
namespace ArzlyAI.Infrastructure.Persistence.Repositories.Workflows;

public sealed class InMemoryWorkflowRunRepository(
    ILogger<InMemoryWorkflowRunRepository> logger) : IWorkflowRunRepository
{
    private readonly ConcurrentDictionary<Guid, WorkflowRun> runs = new();
    public Task AddAsync(WorkflowRun run, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowRunRepository.Add");
        runs[run.Id] = run;
        logger.LogDebug("Stored ephemeral workflow run {RunId} until {ExpiresAtUtc}", run.Id, run.ExpiresAtUtc);
        return Task.CompletedTask;
    }
    public Task<WorkflowRun?> GetAsync(Guid runId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowRunRepository.Get");
        if (!runs.TryGetValue(runId, out var run))
        {
            logger.LogWarning("Ephemeral workflow run {RunId} was not found", runId);
            return Task.FromResult<WorkflowRun?>(null);
        }
        if (run.ExpiresAtUtc <= DateTimeOffset.UtcNow)
        {
            runs.TryRemove(runId, out _);
            logger.LogWarning("Ephemeral workflow run {RunId} expired and was removed", runId);
            return Task.FromResult<WorkflowRun?>(null);
        }
        return Task.FromResult<WorkflowRun?>(run);
    }
    public Task UpdateAsync(WorkflowRun run, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowRunRepository.Update");
        runs[run.Id] = run;
        logger.LogDebug("Updated ephemeral workflow run {RunId} to {RunStatus}", run.Id, run.Status);
        return Task.CompletedTask;
    }
}
