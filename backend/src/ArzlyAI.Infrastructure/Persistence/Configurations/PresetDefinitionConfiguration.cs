using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class PresetDefinitionConfiguration : IEntityTypeConfiguration<PresetDefinition>
{
    public void Configure(EntityTypeBuilder<PresetDefinition> builder)
    {
        builder.ToTable("Presets");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => new { x.Key, x.Version }).IsUnique();
        builder.Property(x => x.Key).HasMaxLength(100);
        builder.HasOne(x => x.Workflow)
            .WithOne(x => x.Preset)
            .HasForeignKey<WorkflowDefinition>(x => x.PresetId);
    }
}
