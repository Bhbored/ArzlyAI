using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Domain.Authoring;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Repositories.Authoring;

public sealed class PresetAuthoringRepository(
    ArzlyDbContext dbContext,
    ILogger<PresetAuthoringRepository> logger) : IPresetAuthoringRepository
{
    public async Task<IReadOnlyList<PresetAuthoringSession>> ListAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.List");
        return await dbContext.PresetAuthoringSessions.AsNoTracking()
            .Include(x => x.Messages).OrderByDescending(x => x.UpdatedAtUtc).ToListAsync(cancellationToken);
    }

    public Task<PresetAuthoringSession?> GetAsync(Guid id, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.Get");
        return dbContext.PresetAuthoringSessions.Include(x => x.Messages)
            .SingleOrDefaultAsync(x => x.Id == id, cancellationToken);
    }

    public async Task AddAsync(PresetAuthoringSession session, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.Add");
        await dbContext.PresetAuthoringSessions.AddAsync(session, cancellationToken);
        await dbContext.SaveChangesAsync(cancellationToken);
        logger.LogInformation("Created preset authoring session {SessionId}", session.Id);
    }

    public Task SaveAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.Save");
        return dbContext.SaveChangesAsync(cancellationToken);
    }
}
