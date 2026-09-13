namespace ArzlyAI.Application.DTOs.Presets;
public sealed record PresetSummaryResponse(
    Guid Id, string Key, string Name, string Description, int Version,
    string? Subtitle = null,
    BackgroundExecutionPolicyResponse? BackgroundExecution = null);
