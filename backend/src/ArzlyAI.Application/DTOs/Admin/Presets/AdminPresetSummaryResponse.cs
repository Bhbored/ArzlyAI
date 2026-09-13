namespace ArzlyAI.Application.DTOs.Admin.Presets;

public sealed record AdminPresetSummaryResponse(
    Guid Id, string Key, string Name, int Version, string Status, DateTimeOffset? PublishedAtUtc);
