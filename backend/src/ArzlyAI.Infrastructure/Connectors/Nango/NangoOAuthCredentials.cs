namespace ArzlyAI.Infrastructure.Connectors.Nango;

public sealed record NangoOAuthCredentials(
    string AccessToken,
    string? Subject,
    string? Email = null);
