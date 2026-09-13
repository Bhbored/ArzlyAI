using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record BackgroundExecutionPolicyDraft(
    BackgroundExecutionMode Mode,
    string Rationale,
    IReadOnlyList<string> AllowedTriggerTypes);
