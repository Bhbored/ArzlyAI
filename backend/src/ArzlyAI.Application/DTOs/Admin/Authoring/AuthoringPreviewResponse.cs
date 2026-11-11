using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringPreviewResponse(int DraftRevision, PresetValidationResult Validation, IReadOnlyList<AuthoringPreviewNodeResponse> Nodes);
