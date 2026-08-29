using ArzlyAI.Application.DTOs.Connectors;
using ArzlyAI.Application.Services.Connectors;
using ArzlyAI.Infrastructure.Configuration;
using ArzlyAI.Infrastructure.Connectors.LinkedIn;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Connectors.Nango;

public sealed class NangoConnectorBroker(
    INangoConnectorClient nango,
    ILinkedInIdentityClient linkedInIdentity,
    IOptions<NangoOptions> options,
    ILogger<NangoConnectorBroker> logger) : IConnectorBroker
{
    public async Task<ConnectorSessionResponse> CreateSessionAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorBroker.CreateSession");
        var definition = Resolve(connectorKey);
        var session = await nango.CreateSessionAsync(
            definition.IntegrationId,
            deviceId.ToString("D"),
            cancellationToken);
        logger.LogInformation("Created Nango connect session for connector {ConnectorKey}", definition.Key);
        return new ConnectorSessionResponse(session.ConnectUrl, session.Token, session.ExpiresAtUtc);
    }

    public async Task<ConnectorStatusResponse> GetStatusAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorBroker.GetStatus");
        var definition = Resolve(connectorKey);
        var connection = await FindConnectionAsync(definition, deviceId, cancellationToken);
        return new ConnectorStatusResponse(
            definition.Key,
            connection is not null,
            connection?.CreatedAtUtc);
    }

    public async Task<IReadOnlyDictionary<string, string>?> GetCredentialsAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorBroker.GetCredentials");
        var definition = Resolve(connectorKey);
        var connection = await FindConnectionAsync(definition, deviceId, cancellationToken);
        if (connection is null) return null;

        var credentials = await nango.GetCredentialsAsync(
            definition.IntegrationId,
            connection.ConnectionId,
            cancellationToken);
        if (definition.Key != "linkedin")
            throw new NotSupportedException($"Credential mapping is not implemented for '{definition.Key}'.");

        var subject = credentials.Subject ?? await linkedInIdentity.GetSubjectAsync(
            credentials.AccessToken,
            cancellationToken);
        var authorUrn = subject.StartsWith("urn:li:person:", StringComparison.Ordinal)
            ? subject
            : $"urn:li:person:{subject}";
        logger.LogInformation("Mapped credentials for connector {ConnectorKey}", definition.Key);
        return new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["linkedin.accessToken"] = credentials.AccessToken,
            ["linkedin.authorUrn"] = authorUrn
        };
    }

    public async Task<bool> DisconnectAsync(
        string connectorKey,
        Guid deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorBroker.Disconnect");
        var definition = Resolve(connectorKey);
        var connections = await nango.ListConnectionsAsync(
            definition.IntegrationId,
            deviceId.ToString("D"),
            cancellationToken);
        foreach (var connection in connections)
            await nango.DeleteConnectionAsync(
                definition.IntegrationId,
                connection.ConnectionId,
                cancellationToken);
        if (connections.Count > 0)
            logger.LogInformation("Disconnected connector {ConnectorKey}", definition.Key);
        return connections.Count > 0;
    }

    private async Task<NangoConnectionSummary?> FindConnectionAsync(
        ConnectorDefinition definition,
        Guid deviceId,
        CancellationToken cancellationToken) =>
        (await nango.ListConnectionsAsync(
            definition.IntegrationId,
            deviceId.ToString("D"),
            cancellationToken)).FirstOrDefault(connection => connection.IsHealthy);

    private ConnectorDefinition Resolve(string connectorKey)
    {
        if (!connectorKey.Equals("linkedin", StringComparison.OrdinalIgnoreCase))
            throw new KeyNotFoundException($"Connector '{connectorKey}' is not supported.");
        var integrationId = options.Value.LinkedInIntegrationId;
        if (string.IsNullOrWhiteSpace(integrationId))
            throw new InvalidOperationException("Nango:LinkedInIntegrationId is not configured.");
        return new ConnectorDefinition("linkedin", integrationId);
    }

    private sealed record ConnectorDefinition(string Key, string IntegrationId);
}
