namespace ArzlyAI.Infrastructure.Connectors.Nango;

public sealed record NangoConnectionSummary(
    string ConnectionId,
    string IntegrationId,
    DateTimeOffset CreatedAtUtc,
    bool IsHealthy);
