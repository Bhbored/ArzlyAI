using ArzlyAI.Application.Repositories;
using ArzlyAI.Domain.Presets;
namespace ArzlyAI.Application.Repositories.Presets;
public interface IPresetRepository : IGenericRepository<PresetDefinition>
{
    Task<IReadOnlyList<PresetDefinition>> ListPublishedAsync(CancellationToken cancellationToken);
    Task<PresetDefinition?> GetPublishedByKeyAsync(string key, CancellationToken cancellationToken);
}
