namespace ArzlyAI.Application.DTOs.Models;

public sealed record ProviderModelResponse(
    string Id,
    string DisplayName,
    string Provider,
    string OwnedBy,
    DateTimeOffset CreatedAtUtc,
    bool SupportsTemperature,
    bool SupportsWebSearch);
