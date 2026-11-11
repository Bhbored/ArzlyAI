using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record SaveAuthoringDraftRequest(int ExpectedRevision, PresetDraftDocument Draft);
