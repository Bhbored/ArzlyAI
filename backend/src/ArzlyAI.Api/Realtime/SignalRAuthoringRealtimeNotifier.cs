using ArzlyAI.Api.Hubs;
using ArzlyAI.Application.Services.Realtime;
using Microsoft.AspNetCore.SignalR;

namespace ArzlyAI.Api.Realtime;

public sealed class SignalRAuthoringRealtimeNotifier(IHubContext<AdminAuthoringHub> hub)
    : IAuthoringRealtimeNotifier
{
    public Task NotifyAsync(
        Guid sessionId, string eventName, object payload, CancellationToken cancellationToken) =>
        hub.Clients.Group(AdminAuthoringHub.GroupName(sessionId))
            .SendAsync(eventName, payload, cancellationToken);
}
