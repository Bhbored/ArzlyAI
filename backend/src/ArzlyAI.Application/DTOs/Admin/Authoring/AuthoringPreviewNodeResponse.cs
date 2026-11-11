namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringPreviewNodeResponse(string Key, string Name, string Type, IReadOnlyList<AuthoringPreviewMappingResponse> Inputs);
