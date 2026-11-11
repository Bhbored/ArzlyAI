using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Repositories.Authoring;

public sealed class PresetAuthoringRepository(
    ArzlyDbContext dbContext,
    DbContextOptions<ArzlyDbContext> dbContextOptions,
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

    public async Task<IReadOnlyList<PresetAuthoringSession>> ListSummariesAsync(CancellationToken cancellationToken) =>
        await dbContext.PresetAuthoringSessions.AsNoTracking().OrderByDescending(x => x.UpdatedAtUtc)
            .Select(x => new PresetAuthoringSession
            {
                Id = x.Id, Title = x.Title, Status = x.Status, Revision = x.Revision,
                AssistantProvider = x.AssistantProvider, AssistantModel = x.AssistantModel,
                UpdatedAtUtc = x.UpdatedAtUtc
            }).ToListAsync(cancellationToken);

    public async Task AddAsync(PresetAuthoringSession session, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.Add");
        await dbContext.PresetAuthoringSessions.AddAsync(session, cancellationToken);
        await dbContext.SaveChangesAsync(cancellationToken);
        logger.LogInformation("Created preset authoring session {SessionId}", session.Id);
    }

    public async Task<bool> TryAddMessageAsync(
        PresetAuthoringSession session,
        PresetAuthoringMessage message,
        int expectedRevision,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.TryAddMessage");
        await using var transaction = await dbContext.Database.BeginTransactionAsync(cancellationToken);
        if (session.Revision != expectedRevision || session.LastTurnStatus == "Running" ||
            session.Status is AuthoringSessionStatus.Published or AuthoringSessionStatus.Abandoned)
        {
            return false;
        }
        session.Revision = checked(expectedRevision + 1);
        session.LastTurnId = message.TurnId;
        session.LastTurnStatus = "Running";
        session.LastTurnError = null;
        session.TurnStartedAtUtc = DateTimeOffset.UtcNow;
        var existing = session.Messages.Any(item => item.Id == message.Id);
        if (!existing) dbContext.Entry(message).State = EntityState.Added;
        try
        {
            await dbContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            if (!existing && !session.Messages.Contains(message)) session.Messages.Add(message);
            return true;
        }
        catch (DbUpdateConcurrencyException)
        {
            await transaction.RollbackAsync(cancellationToken);
            dbContext.ChangeTracker.Clear();
            return false;
        }
    }

    public async Task AddMessageAsync(
        PresetAuthoringSession session,
        PresetAuthoringMessage message,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.AddMessage");
        await using var messageContext = new ArzlyDbContext(dbContextOptions);
        messageContext.Entry(message).State = EntityState.Added;
        await messageContext.SaveChangesAsync(cancellationToken);

        session.Messages.Add(message);
        dbContext.Entry(message).State = EntityState.Unchanged;
    }

    public async Task DeleteAsync(
        PresetAuthoringSession session,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.Delete");
        dbContext.PresetAuthoringSessions.Remove(session);
        await dbContext.SaveChangesAsync(cancellationToken);
        logger.LogInformation("Deleted preset authoring session {SessionId}", session.Id);
    }

    public async Task SaveAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringRepository.Save");
        try
        {
            await dbContext.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateConcurrencyException exception)
        {
            throw new AuthoringSessionConflictException(
                "The authoring session changed while it was being edited. Reload the session and retry.",
                exception);
        }
    }
}
