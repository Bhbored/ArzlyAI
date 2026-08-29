using ArzlyAI.Application.DTOs.Workflows;
namespace ArzlyAI.Api.Hubs;
public interface IWorkflowClient
{
    Task NodeChanged(WorkflowNodeChangedEvent message);
}
