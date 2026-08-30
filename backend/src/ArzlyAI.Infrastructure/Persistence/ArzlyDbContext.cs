using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Infrastructure.Persistence.Seeds;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence;

public sealed class ArzlyDbContext(DbContextOptions<ArzlyDbContext> options) : DbContext(options)
{
    public DbSet<ProviderDefinition> Providers => Set<ProviderDefinition>();
    public DbSet<ModelDefinition> Models => Set<ModelDefinition>();
    public DbSet<IntegrationDefinition> Integrations => Set<IntegrationDefinition>();
    public DbSet<PresetDefinition> Presets => Set<PresetDefinition>();
    public DbSet<AgentDefinition> Agents => Set<AgentDefinition>();
    public DbSet<AgentHarnessDefinition> AgentHarnesses => Set<AgentHarnessDefinition>();
    public DbSet<WorkflowDefinition> Workflows => Set<WorkflowDefinition>();
    public DbSet<WorkflowStepDefinition> WorkflowSteps => Set<WorkflowStepDefinition>();
    public DbSet<WorkflowConnectionDefinition> WorkflowConnections => Set<WorkflowConnectionDefinition>();

    public async Task InitializeAsync(CancellationToken cancellationToken = default)
    {
        using var operation = Operation.Time("ArzlyDbContext.Initialize");
        await Database.MigrateAsync(cancellationToken);
        await ProviderCatalogSeed.SeedAsync(this, cancellationToken);
        await LinkedInPresetSeed.SeedAsync(this, cancellationToken);
        await SmartPurchaseDecisionPresetSeed.SeedAsync(this, cancellationToken);
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ArzlyDbContext).Assembly);
    }
}
