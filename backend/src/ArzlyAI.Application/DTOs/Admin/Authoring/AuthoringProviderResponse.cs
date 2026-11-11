namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AuthoringProviderResponse(
    string Provider,
    string DisplayName,
    string IconKey,
    bool HasApiKey,
    bool IsEnabled,
    bool IsAvailable,
    string? UnavailableReason,
    IReadOnlyList<AuthoringModelResponse> Models);
