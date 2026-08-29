namespace ArzlyAI.Application.Abstractions;

public interface IWorkflowScheduler
{
    Task ScheduleDailyAsync(
        string workflowId,
        TimeOnly localTime,
        string timeZoneId,
        CancellationToken cancellationToken);

    Task UnscheduleAsync(string workflowId, CancellationToken cancellationToken);
}
