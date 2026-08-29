using ArzlyAI.Application.DTOs.Presets;
using ArzlyAI.Application.Mappers.Presets;
using ArzlyAI.Application.Repositories.Presets;
using ArzlyAI.Domain.Presets;
using Microsoft.Extensions.Logging;
using SerilogTimings;
namespace ArzlyAI.Application.Services.Presets;

public sealed class PresetService(
    IPresetRepository repository,
    IPresetMapper mapper,
    ILogger<PresetService> logger) : IPresetService
{
    public async Task<IReadOnlyList<PresetSummaryResponse>> GetAllAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetService.GetAll");
        logger.LogDebug("Loading published preset summaries");
        var presets = (await repository.ListPublishedAsync(cancellationToken))
            .Select(mapper.ToSummaryResponse).ToList();
        logger.LogInformation("Loaded {PresetCount} published presets", presets.Count);
        return presets;
    }

    public async Task<PresetDetailsResponse?> GetByKeyAsync(string key, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetService.GetByKey");
        logger.LogDebug("Loading preset {PresetKey}", key);
        var preset = await repository.GetPublishedByKeyAsync(key, cancellationToken);
        if (preset is null) logger.LogWarning("Published preset {PresetKey} was not found", key);
        return preset is null ? null : mapper.ToDetailsResponse(preset);
    }

    public async Task<PresetDefinition?> GetEntityByKeyAsync(string key, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetService.GetEntityByKey");
        logger.LogDebug("Loading preset entity {PresetKey} for execution", key);
        return await repository.GetPublishedByKeyAsync(key, cancellationToken);
    }

}
