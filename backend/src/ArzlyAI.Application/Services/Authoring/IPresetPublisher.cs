namespace ArzlyAI.Application.Services.Authoring;

public interface IPresetPublisher
{
    Task<Guid> PublishAsync(Guid sessionId, Guid adminId, int expectedRevision, CancellationToken cancellationToken);
}
