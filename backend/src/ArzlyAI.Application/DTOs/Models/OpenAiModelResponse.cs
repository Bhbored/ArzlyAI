namespace ArzlyAI.Application.DTOs.Models;

public sealed record OpenAiModelResponse(
    string Id,
    string DisplayName,
    string OwnedBy,
    DateTimeOffset CreatedAtUtc,
    bool SupportsTemperature);
