using ArzlyAI.Application.DTOs.Workflows;
namespace ArzlyAI.Application.Services.Realtime;
public interface IWorkflowRealtimeNotifier
{
    Task NodeChangedAsync(WorkflowNodeChangedEvent message, CancellationToken cancellationToken);
}
