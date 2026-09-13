namespace ArzlyAI.Application.DTOs.Presets;

public sealed record BackgroundExecutionPolicyResponse(
    string Mode, string? Rationale, string AllowedTriggerTypesJson);
