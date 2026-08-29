namespace ArzlyAI.Application.DTOs.Connectors;

public sealed record ConnectorSessionResponse(
    string ConnectUrl,
    string SessionToken,
    DateTimeOffset ExpiresAtUtc);
