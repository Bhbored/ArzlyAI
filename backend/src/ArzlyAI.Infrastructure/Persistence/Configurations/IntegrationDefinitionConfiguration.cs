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
        builder.Property(x => x.CredentialSchemaJson).HasColumnType("jsonb");
        builder.Property(x => x.InputSchemaJson).HasColumnType("jsonb");
        builder.Property(x => x.OutputSchemaJson).HasColumnType("jsonb");
        builder.Property(x => x.RequiredOAuthScopesJson).HasColumnType("jsonb");
        builder.Property(x => x.RequiredApisJson).HasColumnType("jsonb");
        builder.Property(x => x.DocumentationLinksJson).HasColumnType("jsonb");
        builder.Property(x => x.RiskLevel).HasConversion<string>();
        builder.HasOne(x => x.Connector).WithMany(x => x.Integrations)
            .HasForeignKey(x => x.ConnectorId).OnDelete(DeleteBehavior.Restrict);
    }
}
