using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Repositories.Authoring;

public interface IPresetPublishingRepository
{
    Task<int> GetNextVersionAsync(string key, CancellationToken cancellationToken);
    Task<Guid?> GetActivePresetIdAsync(string key, CancellationToken cancellationToken);
    Task<IReadOnlyList<PresetDefinition>> ListVersionsAsync(CancellationToken cancellationToken);
    Task<PresetDefinition?> GetVersionAsync(string key, int version, CancellationToken cancellationToken);
    Task ArchiveAsync(PresetDefinition preset, CancellationToken cancellationToken);
    Task PublishAsync(PresetAuthoringSession session, PresetDefinition preset, CancellationToken cancellationToken);
}
