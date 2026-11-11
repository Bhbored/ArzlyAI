namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringTurnStateResponse(Guid Id, string Status, DateTimeOffset? StartedAtUtc, string? Error);
