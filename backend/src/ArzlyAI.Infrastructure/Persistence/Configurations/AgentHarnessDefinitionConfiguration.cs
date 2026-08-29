using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class AgentHarnessDefinitionConfiguration : IEntityTypeConfiguration<AgentHarnessDefinition>
{
    public void Configure(EntityTypeBuilder<AgentHarnessDefinition> builder)
    {
        builder.ToTable("AgentHarnesses");
        builder.HasKey(x => x.Id);
    }
}
