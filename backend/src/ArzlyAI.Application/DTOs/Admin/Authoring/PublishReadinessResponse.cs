namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record PublishReadinessResponse(bool CanPublish, IReadOnlyList<string> Blockers);
