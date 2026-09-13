using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftAdminNote(
    string Title,
    string Description,
    AdminNoteSeverity Severity,
    IReadOnlyList<string> Links);
