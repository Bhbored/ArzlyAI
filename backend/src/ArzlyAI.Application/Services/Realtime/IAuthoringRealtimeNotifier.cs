namespace ArzlyAI.Application.Services.Realtime;

public interface IAuthoringRealtimeNotifier
{
    Task NotifyAsync(
        Guid sessionId, string eventName, object payload, CancellationToken cancellationToken);
}
