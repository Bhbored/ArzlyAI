namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringModelResponse(
    string Provider,
    string Model,
    string DisplayName,
    bool SupportsToolCalling,
    bool SupportsTemperature,
    bool SupportsWebSearch,
    bool IsAvailable,
    bool IsDefault);
