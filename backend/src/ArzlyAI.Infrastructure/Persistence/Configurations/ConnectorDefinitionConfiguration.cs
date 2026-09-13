using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class ConnectorDefinitionConfiguration : IEntityTypeConfiguration<ConnectorDefinition>
{
    public void Configure(EntityTypeBuilder<ConnectorDefinition> builder)
    {
        builder.ToTable("Connectors");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => x.Key).IsUnique();
        builder.Property(x => x.Key).HasMaxLength(100);
        builder.Property(x => x.AuthenticationType).HasMaxLength(50);
    }
}
