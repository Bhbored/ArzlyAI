using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class AgentDefinitionConfiguration : IEntityTypeConfiguration<AgentDefinition>
{
    public void Configure(EntityTypeBuilder<AgentDefinition> builder)
    {
        builder.ToTable("PresetAgents");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => new { x.PresetId, x.Key }).IsUnique();
        builder.Property(x => x.RuntimeType).HasConversion<string>();
        builder.Property(x => x.OutputSchemaJson).HasColumnType("jsonb");
        builder.HasOne(x => x.Harness)
            .WithOne(x => x.Agent)
            .HasForeignKey<AgentHarnessDefinition>(x => x.AgentId);
    }
}
