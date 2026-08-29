using ArzlyAI.Application.DTOs.Workflows;
namespace ArzlyAI.Application.Services.Workflows;
public interface IWorkflowExecutionService
{
    Task<WorkflowRunResponse> StartAsync(StartWorkflowRequest request, CancellationToken cancellationToken);
    Task<WorkflowRunResponse?> GetAsync(Guid runId, CancellationToken cancellationToken);
    Task<WorkflowRunResponse> SubmitApprovalAsync(Guid runId, SubmitApprovalRequest request, CancellationToken cancellationToken);
}
