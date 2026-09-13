using ArzlyAI.Domain.Authoring;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class PresetAuthoringSessionConfiguration : IEntityTypeConfiguration<PresetAuthoringSession>
{
    public void Configure(EntityTypeBuilder<PresetAuthoringSession> builder)
    {
        builder.ToTable("PresetAuthoringSessions");
        builder.HasKey(x => x.Id);
        builder.Property(x => x.AssistantProvider).HasMaxLength(32);
        builder.Property(x => x.AssistantModel).HasMaxLength(160);
        builder.Property(x => x.Status).HasConversion<string>();
        builder.Property(x => x.DraftJson).HasColumnType("jsonb");
        builder.Property(x => x.ValidationJson).HasColumnType("jsonb");
        builder.Property(x => x.Revision).IsConcurrencyToken();
    }
}
