using System.Text.Json;

namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record PreviewAuthoringDraftRequest(int ExpectedRevision, JsonElement SampleInputs);
