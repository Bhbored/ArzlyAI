using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringSessionResponse(
    Guid Id,
    string? Title,
    string Status,
    int Revision,
    AuthoringModelSelectionResponse AssistantModel,
    PresetDraftDocument? Draft,
    PresetValidationResult Validation,
    Guid? PublishedPresetId,
    IReadOnlyList<AuthoringMessageResponse> Messages,
    DateTimeOffset CreatedAtUtc,
    DateTimeOffset UpdatedAtUtc);
