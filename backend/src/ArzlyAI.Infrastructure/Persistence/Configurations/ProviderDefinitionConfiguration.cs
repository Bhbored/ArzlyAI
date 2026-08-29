using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class ProviderDefinitionConfiguration : IEntityTypeConfiguration<ProviderDefinition>
{
    public void Configure(EntityTypeBuilder<ProviderDefinition> builder)
    {
        builder.ToTable("Providers");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => x.Key).IsUnique();
        builder.Property(x => x.Key).HasMaxLength(50);
        builder.Property(x => x.DisplayName).HasMaxLength(100);
    }
}
