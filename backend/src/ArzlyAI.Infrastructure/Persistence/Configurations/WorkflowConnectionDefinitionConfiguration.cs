using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class WorkflowConnectionDefinitionConfiguration : IEntityTypeConfiguration<WorkflowConnectionDefinition>
{
    public void Configure(EntityTypeBuilder<WorkflowConnectionDefinition> builder)
    {
        builder.ToTable("PresetWorkflowConnections");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => new { x.WorkflowId, x.SourceStepId, x.TargetStepId }).IsUnique();
    }
}
