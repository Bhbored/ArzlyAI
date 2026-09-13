using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Infrastructure.Identity;
using ArzlyAI.Infrastructure.Persistence.Seeds;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence;

public sealed class ArzlyDbContext(DbContextOptions<ArzlyDbContext> options)
    : IdentityDbContext<ApplicationUser, ApplicationRole, Guid>(options)
{
    public DbSet<ProviderDefinition> Providers => Set<ProviderDefinition>();
    public DbSet<ModelDefinition> Models => Set<ModelDefinition>();
    public DbSet<IntegrationDefinition> Integrations => Set<IntegrationDefinition>();
    public DbSet<ConnectorDefinition> Connectors => Set<ConnectorDefinition>();
    public DbSet<WorkflowOperationDefinition> WorkflowOperations => Set<WorkflowOperationDefinition>();
    public DbSet<PresetDefinition> Presets => Set<PresetDefinition>();
    public DbSet<AgentDefinition> Agents => Set<AgentDefinition>();
    public DbSet<AgentHarnessDefinition> AgentHarnesses => Set<AgentHarnessDefinition>();
    public DbSet<WorkflowDefinition> Workflows => Set<WorkflowDefinition>();
    public DbSet<WorkflowStepDefinition> WorkflowSteps => Set<WorkflowStepDefinition>();
    public DbSet<WorkflowConnectionDefinition> WorkflowConnections => Set<WorkflowConnectionDefinition>();
    public DbSet<PresetAdminNote> PresetAdminNotes => Set<PresetAdminNote>();
    public DbSet<PresetAuthoringSession> PresetAuthoringSessions => Set<PresetAuthoringSession>();
    public DbSet<PresetAuthoringMessage> PresetAuthoringMessages => Set<PresetAuthoringMessage>();

    public async Task InitializeAsync(CancellationToken cancellationToken = default)
    {
        using var operation = Operation.Time("ArzlyDbContext.Initialize");
        await Database.MigrateAsync(cancellationToken);
        await ProviderCatalogSeed.SeedAsync(this, cancellationToken);
        await CapabilityCatalogSeed.SeedAsync(this, cancellationToken);
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ArzlyDbContext).Assembly);
    }
}
