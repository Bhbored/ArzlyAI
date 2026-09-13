using ArzlyAI.Application.DTOs.Presets;

namespace ArzlyAI.Application.DTOs.Admin.Presets;

public sealed record AdminPresetDetailsResponse(
    PresetDetailsResponse Preset,
    string Status,
    Guid? PublishedByAdminId,
    Guid? SupersedesPresetId,
    IReadOnlyList<AdminNoteResponse> AdminNotes);
