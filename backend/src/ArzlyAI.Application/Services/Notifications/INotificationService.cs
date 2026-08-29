namespace ArzlyAI.Application.Services.Notifications;
public interface INotificationService
{
    Task WorkflowNeedsApprovalAsync(Guid runId, string presetName, CancellationToken cancellationToken);
    Task WorkflowCompletedAsync(Guid runId, string presetName, CancellationToken cancellationToken);
}
