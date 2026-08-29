using ArzlyAI.Api.Hubs;
using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Services.Realtime;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using SerilogTimings;
namespace ArzlyAI.Api.Realtime;

public sealed class SignalRWorkflowRealtimeNotifier(
    IHubContext<WorkflowHub, IWorkflowClient> hubContext,
    ILogger<SignalRWorkflowRealtimeNotifier> logger) : IWorkflowRealtimeNotifier
{
    public async Task NodeChangedAsync(WorkflowNodeChangedEvent message, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("SignalRWorkflowRealtimeNotifier.NodeChanged");
        logger.LogDebug("Sending node {NodeKey} status {NodeStatus} for run {RunId}",
            message.NodeKey, message.Status, message.RunId);
        await hubContext.Clients.Group(message.RunId.ToString()).NodeChanged(message);
    }
}
