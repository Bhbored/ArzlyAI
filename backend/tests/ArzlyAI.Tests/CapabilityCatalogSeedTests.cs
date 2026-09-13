using ArzlyAI.Infrastructure.Persistence;
using ArzlyAI.Infrastructure.Persistence.Seeds;
using Microsoft.EntityFrameworkCore;

namespace ArzlyAI.Tests;

public sealed class CapabilityCatalogSeedTests
{
    [Fact]
    public async Task SeedAsync_WhenCalledTwice_RemainsIdempotent()
    {
        await using var db = CreateContext();

        await CapabilityCatalogSeed.SeedAsync(db);
        await CapabilityCatalogSeed.SeedAsync(db);

        Assert.Equal(2, await db.Connectors.CountAsync());
        Assert.Equal(7, await db.Integrations.CountAsync());
        Assert.Equal(2, await db.WorkflowOperations.CountAsync());
        Assert.All(await db.Integrations.ToListAsync(), item => Assert.NotEqual("{}", item.InputSchemaJson));
    }

    private static ArzlyDbContext CreateContext() => new(
        new DbContextOptionsBuilder<ArzlyDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString()).Options);
}
