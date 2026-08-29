using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class ModelDefinitionConfiguration : IEntityTypeConfiguration<ModelDefinition>
{
    public void Configure(EntityTypeBuilder<ModelDefinition> builder)
    {
        builder.ToTable("Models");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => new { x.ProviderId, x.Key }).IsUnique();
        builder.Property(x => x.Key).HasMaxLength(100);
    }
}
