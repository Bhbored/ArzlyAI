namespace ArzlyAI.Application.DTOs.Connectors;

public sealed record ConnectorStatusResponse(
    string ConnectorKey,
    bool IsConnected,
    DateTimeOffset? ConnectedAtUtc);
