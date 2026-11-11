using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Infrastructure.Persistence;
using ArzlyAI.Infrastructure.Persistence.Repositories.Authoring;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;

namespace ArzlyAI.Tests;

public sealed class AdminWorkflowCatalogTests
{
    [Fact]
    public async Task ListVersionsAsync_WhenLegacyRowsExist_ReturnsOnlyAdminPublishedWorkflows()
    {
        var options = new DbContextOptionsBuilder<ArzlyDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString()).Options;
        await using var context = new ArzlyDbContext(options);
        var adminId = Guid.NewGuid();
        context.Presets.AddRange(
            new PresetDefinition { Id = Guid.NewGuid(), Key = "legacy", Name = "Legacy", Description = "Legacy", Version = 1 },
            new PresetDefinition { Id = Guid.NewGuid(), Key = "created", Name = "Created", Description = "Created", Version = 1,
                Status = PresetPublicationStatus.Archived, PublishedByAdminId = adminId },
            new PresetDefinition { Id = Guid.NewGuid(), Key = "created", Name = "Created", Description = "Created", Version = 2,
                Status = PresetPublicationStatus.Published, PublishedByAdminId = adminId });
        await context.SaveChangesAsync();
        var repository = new PresetPublishingRepository(context, NullLogger<PresetPublishingRepository>.Instance);

        var versions = await repository.ListVersionsAsync(CancellationToken.None);

        Assert.Equal([2, 1], versions.Select(preset => preset.Version));
        Assert.All(versions, preset => Assert.Equal(adminId, preset.PublishedByAdminId));
    }
}
