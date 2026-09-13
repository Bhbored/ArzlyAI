using ArzlyAI.Domain.Authoring;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class PresetAuthoringMessageConfiguration : IEntityTypeConfiguration<PresetAuthoringMessage>
{
    public void Configure(EntityTypeBuilder<PresetAuthoringMessage> builder)
    {
        builder.ToTable("PresetAuthoringMessages");
        builder.HasKey(x => x.Id);
        builder.HasIndex(x => new { x.SessionId, x.Sequence }).IsUnique();
        builder.Property(x => x.Role).HasConversion<string>();
        builder.Property(x => x.ToolPayloadJson).HasColumnType("jsonb");
        builder.HasOne(x => x.Session).WithMany(x => x.Messages)
            .HasForeignKey(x => x.SessionId).OnDelete(DeleteBehavior.Cascade);
    }
}
