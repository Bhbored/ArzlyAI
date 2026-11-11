namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringSessionSummaryResponse(Guid Id, string? Title, string Status, int Revision,
    AuthoringModelSelectionResponse AssistantModel, DateTimeOffset UpdatedAtUtc);
