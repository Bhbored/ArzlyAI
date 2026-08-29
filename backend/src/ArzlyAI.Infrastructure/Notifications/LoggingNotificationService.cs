using ArzlyAI.Application.Services.Notifications;
using Microsoft.Extensions.Logging;
using SerilogTimings;
namespace ArzlyAI.Infrastructure.Notifications;

public sealed class LoggingNotificationService(ILogger<LoggingNotificationService> logger) : INotificationService
{
    public Task WorkflowNeedsApprovalAsync(Guid runId, string presetName, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("LoggingNotificationService.WorkflowNeedsApproval");
        logger.LogInformation("Workflow {RunId} ({Preset}) needs user approval", runId, presetName);
        return Task.CompletedTask;
    }
    public Task WorkflowCompletedAsync(Guid runId, string presetName, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("LoggingNotificationService.WorkflowCompleted");
        logger.LogInformation("Workflow {RunId} ({Preset}) completed", runId, presetName);
        return Task.CompletedTask;
    }
}
