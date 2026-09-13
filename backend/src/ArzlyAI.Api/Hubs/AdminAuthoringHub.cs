using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace ArzlyAI.Api.Hubs;

[Authorize(Roles = "Admin")]
public sealed class AdminAuthoringHub : Hub
{
    public Task JoinSession(Guid sessionId) =>
        Groups.AddToGroupAsync(Context.ConnectionId, GroupName(sessionId));

    public Task LeaveSession(Guid sessionId) =>
        Groups.RemoveFromGroupAsync(Context.ConnectionId, GroupName(sessionId));

    public static string GroupName(Guid sessionId) => $"authoring:{sessionId:N}";
}
