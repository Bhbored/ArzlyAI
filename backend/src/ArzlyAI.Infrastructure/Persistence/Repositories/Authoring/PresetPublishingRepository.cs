using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SerilogTimings;
using Npgsql;

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
        await dbContext.Presets.AsNoTracking().Where(x => x.PublishedByAdminId != null)
            .OrderBy(x => x.Key).ThenByDescending(x => x.Version)
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
        session.Status = AuthoringSessionStatus.Published;
        session.PublishedPresetId = preset.Id;
        session.Revision++;
        try
        {
            await dbContext.SaveChangesAsync(cancellationToken);
            await dbContext.Presets.AddAsync(preset, cancellationToken);
            await dbContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);
        }
        catch (DbUpdateException exception) when (exception is DbUpdateConcurrencyException ||
            exception.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation })
        {
            await transaction.RollbackAsync(cancellationToken);
            throw new AuthoringSessionConflictException("Another publish or edit finished first. Reload the draft and review the current catalog version.", exception);
        }
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
