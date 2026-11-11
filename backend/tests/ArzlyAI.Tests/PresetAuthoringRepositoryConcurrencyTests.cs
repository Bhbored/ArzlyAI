using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Infrastructure.Persistence;
using ArzlyAI.Infrastructure.Persistence.Repositories.Authoring;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.Logging.Abstractions;

namespace ArzlyAI.Tests;

public sealed class PresetAuthoringRepositoryConcurrencyTests
{
    [Fact]
    public async Task SaveAsync_WhenRevisionChangedByAnotherWriter_ThrowsAuthoringSessionConflict()
    {
        var databaseRoot = new InMemoryDatabaseRoot();
        var options = new DbContextOptionsBuilder<ArzlyDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString(), databaseRoot)
            .Options;
        var sessionId = Guid.NewGuid();

        await using (var setup = new ArzlyDbContext(options))
        {
            setup.PresetAuthoringSessions.Add(new PresetAuthoringSession
            {
                Id = sessionId,
                CreatedByAdminId = Guid.NewGuid(),
                Status = AuthoringSessionStatus.Active
            });
            await setup.SaveChangesAsync();
        }

        await using var firstContext = new ArzlyDbContext(options);
        await using var secondContext = new ArzlyDbContext(options);
        var firstRepository = new PresetAuthoringRepository(
            firstContext, options, NullLogger<PresetAuthoringRepository>.Instance);
        var secondRepository = new PresetAuthoringRepository(
            secondContext, options, NullLogger<PresetAuthoringRepository>.Instance);
        var firstSession = await firstRepository.GetAsync(sessionId, CancellationToken.None);
        var secondSession = await secondRepository.GetAsync(sessionId, CancellationToken.None);
        Assert.NotNull(firstSession);
        Assert.NotNull(secondSession);

        firstSession.Revision++;
        await firstRepository.SaveAsync(CancellationToken.None);
        secondSession.Revision++;

        var exception = await Assert.ThrowsAsync<AuthoringSessionConflictException>(
            () => secondRepository.SaveAsync(CancellationToken.None));

        Assert.IsType<DbUpdateConcurrencyException>(exception.InnerException);
    }

    [Fact]
    public async Task AddMessageAsync_WhenTrackedSessionIsStale_InsertsOnlyMessage()
    {
        var databaseRoot = new InMemoryDatabaseRoot();
        var options = new DbContextOptionsBuilder<ArzlyDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString(), databaseRoot)
            .Options;
        var sessionId = Guid.NewGuid();

        await using (var setup = new ArzlyDbContext(options))
        {
            setup.PresetAuthoringSessions.Add(new PresetAuthoringSession
            {
                Id = sessionId,
                CreatedByAdminId = Guid.NewGuid(),
                Title = "Original",
                Status = AuthoringSessionStatus.Active
            });
            await setup.SaveChangesAsync();
        }

        await using var staleContext = new ArzlyDbContext(options);
        var repository = new PresetAuthoringRepository(
            staleContext, options, NullLogger<PresetAuthoringRepository>.Instance);
        var staleSession = await repository.GetAsync(sessionId, CancellationToken.None);
        Assert.NotNull(staleSession);

        await using (var competingContext = new ArzlyDbContext(options))
        {
            var currentSession = await competingContext.PresetAuthoringSessions.SingleAsync();
            currentSession.Revision++;
            await competingContext.SaveChangesAsync();
        }

        staleSession.Title = "Stale update that must not be persisted";
        var message = new PresetAuthoringMessage
        {
            Id = Guid.NewGuid(),
            SessionId = sessionId,
            Session = staleSession,
            Sequence = 1,
            Role = AuthoringMessageRole.Tool,
            Content = "Tool completed."
        };

        await repository.AddMessageAsync(staleSession, message, CancellationToken.None);

        await using var verificationContext = new ArzlyDbContext(options);
        var persistedSession = await verificationContext.PresetAuthoringSessions.AsNoTracking().SingleAsync();
        Assert.Equal("Original", persistedSession.Title);
        Assert.Equal(1, persistedSession.Revision);
        Assert.Equal(1, await verificationContext.PresetAuthoringMessages.CountAsync());
    }
}
