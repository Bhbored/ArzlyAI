namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringTurnResponse(AuthoringSessionResponse Session, string AssistantMessage);
