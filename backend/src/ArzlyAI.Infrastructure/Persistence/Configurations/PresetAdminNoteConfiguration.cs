using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ArzlyAI.Infrastructure.Persistence.Configurations;

public sealed class PresetAdminNoteConfiguration : IEntityTypeConfiguration<PresetAdminNote>
{
    public void Configure(EntityTypeBuilder<PresetAdminNote> builder)
    {
        builder.ToTable("PresetAdminNotes");
        builder.HasKey(x => x.Id);
        builder.Property(x => x.Severity).HasConversion<string>();
        builder.Property(x => x.LinksJson).HasColumnType("jsonb");
        builder.HasOne(x => x.Preset).WithMany(x => x.AdminNotes)
            .HasForeignKey(x => x.PresetId).OnDelete(DeleteBehavior.Cascade);
    }
}
