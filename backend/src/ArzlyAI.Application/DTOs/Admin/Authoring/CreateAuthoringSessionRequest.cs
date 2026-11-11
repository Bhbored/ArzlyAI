namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record CreateAuthoringSessionRequest(
    string? Title, string? Provider = null, string? Model = null, bool UseVisualBuilder = false);
