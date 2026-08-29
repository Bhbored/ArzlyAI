using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class PresetIntegrationConfiguration : IEntityTypeConfiguration<PresetIntegration>
{
    public void Configure(EntityTypeBuilder<PresetIntegration> builder)
    {
        builder.ToTable("PresetIntegrations");
        builder.HasKey(x => new { x.PresetId, x.IntegrationId });
        builder.HasOne(x => x.Integration)
            .WithMany()
            .HasForeignKey(x => x.IntegrationId);
    }
}
