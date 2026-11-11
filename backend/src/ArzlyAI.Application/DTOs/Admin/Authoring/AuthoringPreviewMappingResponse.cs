using System.Text.Json;

namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringPreviewMappingResponse(string Input, string Source, string Status, JsonElement? Value);
