namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringModelResponse(
    string Provider,
    string Model,
    string DisplayName,
    bool SupportsTemperature,
    bool SupportsWebSearch,
    bool IsDefault);
