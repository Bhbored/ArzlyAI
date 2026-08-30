using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using ArzlyAI.Infrastructure.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Connectors.Nango;

public sealed class NangoConnectorClient(
    HttpClient httpClient,
    IOptions<NangoOptions> options,
    ILogger<NangoConnectorClient> logger) : INangoConnectorClient
{
    public async Task<NangoConnectSession> CreateSessionAsync(
        string integrationId,
        string deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorClient.CreateSession");
        using var request = CreateRequest(HttpMethod.Post, "connect/sessions");
        request.Content = JsonContent.Create(new
        {
            tags = new Dictionary<string, string> { ["end_user_id"] = deviceId },
            allowed_integrations = new[] { integrationId }
        });
        using var response = await httpClient.SendAsync(request, cancellationToken);
        EnsureSuccess(response, "create connect session");
        using var payload = await ReadJsonAsync(response, cancellationToken);
        var data = payload.RootElement.GetProperty("data");
        return new NangoConnectSession(
            RequiredString(data, "connect_link"),
            RequiredString(data, "token"),
            data.GetProperty("expires_at").GetDateTimeOffset());
    }

    public async Task<IReadOnlyList<NangoConnectionSummary>> ListConnectionsAsync(
        string integrationId,
        string deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorClient.ListConnections");
        var path = $"connections?tags%5Bend_user_id%5D={Uri.EscapeDataString(deviceId)}&limit=100";
        using var request = CreateRequest(HttpMethod.Get, path);
        using var response = await httpClient.SendAsync(request, cancellationToken);
        EnsureSuccess(response, "list connections");
        using var payload = await ReadJsonAsync(response, cancellationToken);

        return payload.RootElement.GetProperty("connections")
            .EnumerateArray()
            .Where(connection => string.Equals(
                RequiredString(connection, "provider_config_key"),
                integrationId,
                StringComparison.Ordinal))
            .Select(connection => new NangoConnectionSummary(
                RequiredString(connection, "connection_id"),
                integrationId,
                ReadCreatedAt(connection),
                !connection.TryGetProperty("errors", out var errors) ||
                errors.ValueKind != JsonValueKind.Array ||
                errors.GetArrayLength() == 0))
            .OrderByDescending(connection => connection.CreatedAtUtc)
            .ToList();
    }

    public async Task<NangoOAuthCredentials> GetCredentialsAsync(
        string integrationId,
        string connectionId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorClient.GetCredentials");
        var path = $"connections/{Uri.EscapeDataString(connectionId)}" +
                   $"?provider_config_key={Uri.EscapeDataString(integrationId)}";
        using var request = CreateRequest(HttpMethod.Get, path);
        using var response = await httpClient.SendAsync(request, cancellationToken);
        EnsureSuccess(response, "get connection credentials");
        using var payload = await ReadJsonAsync(response, cancellationToken);
        var root = payload.RootElement;
        var credentials = root.GetProperty("credentials");
        var accessToken = OptionalString(credentials, "access_token") ??
                          OptionalString(credentials, "oauth_token") ??
                          throw new InvalidOperationException(
                              "Nango connection did not contain an OAuth access token.");
        var subject = ReadSubject(root, credentials);
        var email = ReadMetadataValue(root, credentials, "email");
        return new NangoOAuthCredentials(accessToken, subject, email);
    }

    public async Task DeleteConnectionAsync(
        string integrationId,
        string connectionId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("NangoConnectorClient.DeleteConnection");
        var path = $"connections/{Uri.EscapeDataString(connectionId)}" +
                   $"?provider_config_key={Uri.EscapeDataString(integrationId)}";
        using var request = CreateRequest(HttpMethod.Delete, path);
        using var response = await httpClient.SendAsync(request, cancellationToken);
        EnsureSuccess(response, "delete connection");
    }

    private HttpRequestMessage CreateRequest(HttpMethod method, string path)
    {
        var apiKey = options.Value.ApiKey;
        if (string.IsNullOrWhiteSpace(apiKey))
            throw new InvalidOperationException("Nango:ApiKey is not configured.");
        var request = new HttpRequestMessage(method, path);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
        return request;
    }

    private void EnsureSuccess(
        HttpResponseMessage response,
        string operation)
    {
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("Nango rejected the configured API key.");
        if (response.IsSuccessStatusCode) return;
        logger.LogError("Nango failed to {Operation} with status {StatusCode}", operation, response.StatusCode);
        throw new HttpRequestException(
            $"Nango failed to {operation} with status {(int)response.StatusCode}.",
            null,
            response.StatusCode);
    }

    private static async Task<JsonDocument> ReadJsonAsync(
        HttpResponseMessage response,
        CancellationToken cancellationToken) =>
        JsonDocument.Parse(await response.Content.ReadAsStreamAsync(cancellationToken));

    private static DateTimeOffset ReadCreatedAt(JsonElement connection)
    {
        var value = OptionalString(connection, "created") ?? OptionalString(connection, "created_at");
        return DateTimeOffset.TryParse(value, out var createdAt) ? createdAt : DateTimeOffset.MinValue;
    }

    private static string? ReadSubject(JsonElement root, JsonElement credentials)
    {
        var metadataSubject = ReadMetadataValue(root, credentials, "sub");
        if (!string.IsNullOrWhiteSpace(metadataSubject)) return metadataSubject;

        if (!credentials.TryGetProperty("raw", out var raw)) return null;
        var idToken = OptionalString(raw, "id_token");
        return string.IsNullOrWhiteSpace(idToken) ? null : ReadJwtSubject(idToken);
    }

    private static string? ReadMetadataValue(
        JsonElement root,
        JsonElement credentials,
        string property)
    {
        if (root.TryGetProperty("metadata", out var metadata))
        {
            var metadataValue = OptionalString(metadata, property);
            if (!string.IsNullOrWhiteSpace(metadataValue)) return metadataValue;
        }

        if (!credentials.TryGetProperty("raw", out var raw)) return null;
        var rawValue = OptionalString(raw, property);
        return string.IsNullOrWhiteSpace(rawValue) ? null : rawValue;
    }

    private static string? ReadJwtSubject(string token)
    {
        var parts = token.Split('.');
        if (parts.Length < 2) return null;
        try
        {
            var value = parts[1].Replace('-', '+').Replace('_', '/');
            value = value.PadRight(value.Length + (4 - value.Length % 4) % 4, '=');
            using var payload = JsonDocument.Parse(Encoding.UTF8.GetString(Convert.FromBase64String(value)));
            return OptionalString(payload.RootElement, "sub");
        }
        catch (FormatException)
        {
            return null;
        }
        catch (JsonException)
        {
            return null;
        }
    }

    private static string RequiredString(JsonElement element, string property) =>
        OptionalString(element, property) ??
        throw new InvalidOperationException($"Nango response did not contain '{property}'.");

    private static string? OptionalString(JsonElement element, string property) =>
        element.ValueKind == JsonValueKind.Object &&
        element.TryGetProperty(property, out var value) &&
        value.ValueKind == JsonValueKind.String
            ? value.GetString()
            : null;
}
