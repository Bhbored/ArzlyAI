namespace ArzlyAI.Application.DTOs.Admin.Auth;

public sealed record AdminRefreshRequest(string AccessToken, string RefreshToken);
