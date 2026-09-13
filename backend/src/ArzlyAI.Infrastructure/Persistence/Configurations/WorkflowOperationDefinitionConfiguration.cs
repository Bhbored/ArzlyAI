using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class WorkflowOperationDefinitionConfiguration : IEntityTypeConfiguration<WorkflowOperationDefinition>
{
    public void Configure(EntityTypeBuilder<WorkflowOperationDefinition> builder)
    {
        builder.ToTable("WorkflowOperations");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => x.Key).IsUnique();
        builder.Property(x => x.Key).HasMaxLength(100);
        builder.Property(x => x.InputSchemaJson).HasColumnType("jsonb");
        builder.Property(x => x.OutputSchemaJson).HasColumnType("jsonb");
    }
}
