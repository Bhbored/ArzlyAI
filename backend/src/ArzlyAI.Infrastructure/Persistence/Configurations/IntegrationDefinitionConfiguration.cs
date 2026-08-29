using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class IntegrationDefinitionConfiguration : IEntityTypeConfiguration<IntegrationDefinition>
{
    public void Configure(EntityTypeBuilder<IntegrationDefinition> builder)
    {
        builder.ToTable("Integrations");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => x.Key).IsUnique();
        builder.Property(x => x.Key).HasMaxLength(50);
    }
}
