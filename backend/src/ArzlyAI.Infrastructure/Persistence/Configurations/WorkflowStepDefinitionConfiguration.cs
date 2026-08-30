using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class WorkflowStepDefinitionConfiguration : IEntityTypeConfiguration<WorkflowStepDefinition>
{
    public void Configure(EntityTypeBuilder<WorkflowStepDefinition> builder)
    {
        builder.ToTable("PresetWorkflowSteps");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => new { x.WorkflowId, x.Position }).IsUnique();
        builder.Property(x => x.Type).HasConversion<string>();
        builder.Property(x => x.ConfigurationJson).HasColumnType("jsonb");
        builder.Property(x => x.ResultContractKey).HasMaxLength(100);
    }
}
