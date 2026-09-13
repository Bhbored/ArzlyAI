namespace ArzlyAI.Application.DTOs.Admin.Presets;

public sealed record AdminNoteResponse(
    string Title, string Description, string Severity, string LinksJson, int DisplayOrder);
