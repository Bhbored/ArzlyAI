using Microsoft.AspNetCore.SignalR;
using SerilogTimings;
namespace ArzlyAI.Api.Hubs;
public sealed class WorkflowHub(ILogger<WorkflowHub> logger) : Hub<IWorkflowClient>
{
    public async Task Subscribe(string workflowId)
    {
        using var operation = Operation.Time("WorkflowHub.Subscribe");
        if (!Guid.TryParse(workflowId, out _)) throw new HubException("A valid workflow identifier is required.");
        logger.LogDebug("Connection {ConnectionId} subscribing to workflow {WorkflowId}", Context.ConnectionId, workflowId);
        await Groups.AddToGroupAsync(Context.ConnectionId, workflowId);
    }
    public async Task Unsubscribe(string workflowId)
    {
        using var operation = Operation.Time("WorkflowHub.Unsubscribe");
        logger.LogDebug("Connection {ConnectionId} unsubscribing from workflow {WorkflowId}", Context.ConnectionId, workflowId);
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, workflowId);
    }

    public async Task SubscribeToRun(Guid runId)
    {
        using var operation = Operation.Time("WorkflowHub.SubscribeToRun");
        logger.LogDebug("Connection {ConnectionId} subscribing to run {RunId}", Context.ConnectionId, runId);
        await Groups.AddToGroupAsync(Context.ConnectionId, runId.ToString());
    }
}
