namespace ArzlyAI.Infrastructure.Connectors.Nango;

public sealed record NangoConnectSession(
    string ConnectUrl,
    string Token,
    DateTimeOffset ExpiresAtUtc);
