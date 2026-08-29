namespace ArzlyAI.Infrastructure.Connectors.Nango;

public interface INangoConnectorClient
{
    Task<NangoConnectSession> CreateSessionAsync(
        string integrationId,
        string deviceId,
        CancellationToken cancellationToken);

    Task<IReadOnlyList<NangoConnectionSummary>> ListConnectionsAsync(
        string integrationId,
        string deviceId,
        CancellationToken cancellationToken);

    Task<NangoOAuthCredentials> GetCredentialsAsync(
        string integrationId,
        string connectionId,
        CancellationToken cancellationToken);

    Task DeleteConnectionAsync(
        string integrationId,
        string connectionId,
        CancellationToken cancellationToken);
}
