using ArzlyAI.Application.Repositories.Presets;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Infrastructure.Persistence.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SerilogTimings;
namespace ArzlyAI.Infrastructure.Persistence.Repositories.Presets;

public sealed class PresetRepository(
    ArzlyDbContext dbContext,
    ILogger<GenericRepository<PresetDefinition>> genericLogger,
    ILogger<PresetRepository> logger)
    : GenericRepository<PresetDefinition>(dbContext, genericLogger), IPresetRepository
{
    public async Task<IReadOnlyList<PresetDefinition>> ListPublishedAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetRepository.ListPublished");
        logger.LogDebug("Querying published presets");
        var presets = await Entities.AsNoTracking().Where(x => x.Status == PresetPublicationStatus.Published)
            .OrderBy(x => x.Name).ToListAsync(cancellationToken);
        logger.LogDebug("Preset query returned {PresetCount} rows", presets.Count);
        return presets;
    }

    public async Task<PresetDefinition?> GetPublishedByKeyAsync(string key, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetRepository.GetPublishedByKey");
        logger.LogDebug("Querying published preset graph {PresetKey}", key);
        var preset = await Query().SingleOrDefaultAsync(
            x => x.Key == key && x.Status == PresetPublicationStatus.Published,
            cancellationToken);
        if (preset is null) logger.LogWarning("Published preset graph {PresetKey} was not found", key);
        return preset;
    }

    private IQueryable<PresetDefinition> Query() => Entities
        .AsNoTrackingWithIdentityResolution().AsSplitQuery()
        .Include(x => x.Agents).ThenInclude(x => x.Model).ThenInclude(x => x.Provider).ThenInclude(x => x.Models)
        .Include(x => x.Agents).ThenInclude(x => x.Harness)
        .Include(x => x.Workflow).ThenInclude(x => x.Steps)
        .Include(x => x.Workflow).ThenInclude(x => x.Connections)
        .Include(x => x.Integrations).ThenInclude(x => x.Integration).ThenInclude(x => x.Connector);
}
