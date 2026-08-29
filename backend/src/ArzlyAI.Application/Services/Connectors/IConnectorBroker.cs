using ArzlyAI.Application.DTOs.Connectors;

namespace ArzlyAI.Application.Services.Connectors;

public interface IConnectorBroker
{
    Task<ConnectorSessionResponse> CreateSessionAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken);

    Task<ConnectorStatusResponse> GetStatusAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken);

    Task<IReadOnlyDictionary<string, string>?> GetCredentialsAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken);

    Task<bool> DisconnectAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken);
}
