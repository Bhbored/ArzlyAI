using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Repositories.Authoring;

public sealed class PresetPublishingRepository(
    ArzlyDbContext dbContext,
    ILogger<PresetPublishingRepository> logger) : IPresetPublishingRepository
{
    public async Task<int> GetNextVersionAsync(string key, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetPublishingRepository.GetNextVersion");
        var latest = await dbContext.Presets.Where(x => x.Key == key)
            .Select(x => (int?)x.Version).MaxAsync(cancellationToken);
        return (latest ?? 0) + 1;
    }

    public Task<Guid?> GetActivePresetIdAsync(string key, CancellationToken cancellationToken) =>
        dbContext.Presets.Where(x => x.Key == key && x.Status == PresetPublicationStatus.Published)
            .Select(x => (Guid?)x.Id).SingleOrDefaultAsync(cancellationToken);

    public async Task<IReadOnlyList<PresetDefinition>> ListVersionsAsync(CancellationToken cancellationToken) =>
        await dbContext.Presets.AsNoTracking().OrderBy(x => x.Key).ThenByDescending(x => x.Version)
            .ToListAsync(cancellationToken);

    public Task<PresetDefinition?> GetVersionAsync(string key, int version, CancellationToken cancellationToken) =>
        GraphQuery().SingleOrDefaultAsync(x => x.Key == key && x.Version == version, cancellationToken);

    public async Task ArchiveAsync(PresetDefinition preset, CancellationToken cancellationToken)
    {
        if (preset.Status == PresetPublicationStatus.Archived) return;
        preset.Status = PresetPublicationStatus.Archived;
        preset.ArchivedAtUtc = DateTimeOffset.UtcNow;
        await dbContext.SaveChangesAsync(cancellationToken);
    }

    public async Task PublishAsync(
        PresetAuthoringSession session,
        PresetDefinition preset,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetPublishingRepository.Publish");
        await using var transaction = await dbContext.Database.BeginTransactionAsync(cancellationToken);
        var active = await dbContext.Presets
            .Where(x => x.Key == preset.Key && x.Status == PresetPublicationStatus.Published)
            .ToListAsync(cancellationToken);
        var now = DateTimeOffset.UtcNow;
        foreach (var current in active)
        {
            current.Status = PresetPublicationStatus.Archived;
            current.ArchivedAtUtc = now;
        }
        await dbContext.Presets.AddAsync(preset, cancellationToken);
        session.Status = AuthoringSessionStatus.Published;
        session.PublishedPresetId = preset.Id;
        await dbContext.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync(cancellationToken);
        logger.LogInformation("Published preset {PresetKey} version {PresetVersion}", preset.Key, preset.Version);
    }

    private IQueryable<PresetDefinition> GraphQuery() => dbContext.Presets.AsSplitQuery()
        .Include(x => x.Agents).ThenInclude(x => x.Model).ThenInclude(x => x.Provider)
        .Include(x => x.Agents).ThenInclude(x => x.Harness)
        .Include(x => x.Workflow).ThenInclude(x => x.Steps)
        .Include(x => x.Workflow).ThenInclude(x => x.Connections)
        .Include(x => x.Integrations).ThenInclude(x => x.Integration).ThenInclude(x => x.Connector)
        .Include(x => x.AdminNotes);
}
