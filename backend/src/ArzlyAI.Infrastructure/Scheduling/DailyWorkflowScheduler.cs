using ArzlyAI.Application.Abstractions;
using Quartz;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Scheduling;

public sealed class DailyWorkflowScheduler(
    ISchedulerFactory schedulerFactory,
    ILogger<DailyWorkflowScheduler> logger) : IWorkflowScheduler
{
    public async Task ScheduleDailyAsync(
        string workflowId,
        TimeOnly localTime,
        string timeZoneId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("DailyWorkflowScheduler.ScheduleDaily");
        var timeZone = TimeZoneInfo.FindSystemTimeZoneById(timeZoneId);
        var scheduler = await schedulerFactory.GetScheduler(cancellationToken);
        var key = new JobKey(workflowId, "workflows");
        var job = JobBuilder.Create<WorkflowDueJob>()
            .WithIdentity(key)
            .UsingJobData(WorkflowDueJob.WorkflowIdKey, workflowId)
            .Build();
        var trigger = TriggerBuilder.Create()
            .WithIdentity(workflowId, "workflow-triggers")
            .WithCronSchedule($"0 {localTime.Minute} {localTime.Hour} ? * *", x =>
                x.InTimeZone(timeZone).WithMisfireHandlingInstructionDoNothing())
            .Build();

        await scheduler.ScheduleJob(job, trigger, cancellationToken);
        logger.LogInformation("Scheduled workflow {WorkflowId} daily at {LocalTime} in {TimeZoneId}",
            workflowId, localTime, timeZoneId);
    }

    public async Task UnscheduleAsync(string workflowId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("DailyWorkflowScheduler.Unschedule");
        var scheduler = await schedulerFactory.GetScheduler(cancellationToken);
        await scheduler.DeleteJob(new JobKey(workflowId, "workflows"), cancellationToken);
        logger.LogInformation("Removed schedule for workflow {WorkflowId}", workflowId);
    }
}
