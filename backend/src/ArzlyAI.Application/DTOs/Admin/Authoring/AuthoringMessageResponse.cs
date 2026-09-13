namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringMessageResponse(
    Guid Id, int Sequence, string Role, string Content, string? ToolName, DateTimeOffset CreatedAtUtc);
