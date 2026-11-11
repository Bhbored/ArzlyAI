using ArzlyAI.Domain.Authoring;

namespace ArzlyAI.Application.Repositories.Authoring;

public interface IPresetAuthoringRepository
{
    Task<IReadOnlyList<PresetAuthoringSession>> ListAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<PresetAuthoringSession>> ListSummariesAsync(CancellationToken cancellationToken) => ListAsync(cancellationToken);
    Task<PresetAuthoringSession?> GetAsync(Guid id, CancellationToken cancellationToken);
    Task AddAsync(PresetAuthoringSession session, CancellationToken cancellationToken);
    Task<bool> TryAddMessageAsync(
        PresetAuthoringSession session,
        PresetAuthoringMessage message,
        int expectedRevision,
        CancellationToken cancellationToken);
    Task AddMessageAsync(
        PresetAuthoringSession session,
        PresetAuthoringMessage message,
        CancellationToken cancellationToken);
    Task DeleteAsync(PresetAuthoringSession session, CancellationToken cancellationToken);
    Task SaveAsync(CancellationToken cancellationToken);
}
