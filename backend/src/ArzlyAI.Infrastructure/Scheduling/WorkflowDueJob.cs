using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Services.Realtime;
using Quartz;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Scheduling;

[DisallowConcurrentExecution]
public sealed class WorkflowDueJob(IWorkflowRealtimeNotifier realtime) : IJob
{
    public const string WorkflowIdKey = "workflowId";

    public async Task Execute(IJobExecutionContext context)
    {
        using var operation = Operation.Time("WorkflowDueJob.Execute");
        var workflowId = context.MergedJobDataMap.GetString(WorkflowIdKey)
            ?? throw new InvalidOperationException("The scheduled workflow has no identifier.");

        await realtime.NodeChangedAsync(
            new WorkflowNodeChangedEvent(Guid.Parse(workflowId), Guid.Empty, "schedule",
                "ExecutionRequested", false,
                "The workflow is due. Send its locally stored payload to execute it.", DateTimeOffset.UtcNow),
            context.CancellationToken);
    }
}
