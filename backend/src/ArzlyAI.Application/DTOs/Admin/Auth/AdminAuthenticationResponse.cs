namespace ArzlyAI.Application.DTOs.Admin.Auth;

public sealed record AdminAuthenticationResponse(
    Guid AdminId,
    string Email,
    string DisplayName,
    string AccessToken,
    DateTimeOffset AccessTokenExpiresAtUtc,
    string RefreshToken,
    DateTimeOffset RefreshTokenExpiresAtUtc);
