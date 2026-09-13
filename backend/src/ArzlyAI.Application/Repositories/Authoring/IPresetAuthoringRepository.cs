using ArzlyAI.Domain.Authoring;

namespace ArzlyAI.Application.Repositories.Authoring;

public interface IPresetAuthoringRepository
{
    Task<IReadOnlyList<PresetAuthoringSession>> ListAsync(CancellationToken cancellationToken);
    Task<PresetAuthoringSession?> GetAsync(Guid id, CancellationToken cancellationToken);
    Task AddAsync(PresetAuthoringSession session, CancellationToken cancellationToken);
    Task SaveAsync(CancellationToken cancellationToken);
}
