using ArzlyAI.Application.DTOs.Presets;
using ArzlyAI.Domain.Presets;
namespace ArzlyAI.Application.Services.Presets;
public interface IPresetService
{
    Task<IReadOnlyList<PresetSummaryResponse>> GetAllAsync(CancellationToken cancellationToken);
    Task<PresetDetailsResponse?> GetByKeyAsync(string key, CancellationToken cancellationToken);
    Task<PresetDefinition?> GetEntityByKeyAsync(string key, CancellationToken cancellationToken);
}
