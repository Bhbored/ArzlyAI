using ArzlyAI.Infrastructure.Configuration;
using ArzlyAI.Infrastructure.Connectors.LinkedIn;
using ArzlyAI.Infrastructure.Connectors.Nango;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace ArzlyAI.Tests;

public sealed class NangoConnectorBrokerTests
{
    [Fact]
    public async Task CreateSessionAsync_WhenDeviceIdValid_ReturnsConnectUrl()
    {
        var client = new NangoClientStub();
        var broker = CreateBroker(client);

        var result = await broker.CreateSessionAsync(
            "linkedin",
            Guid.NewGuid(),
            CancellationToken.None);

        Assert.Equal("https://connect.nango.dev/session", result.ConnectUrl);
        Assert.Equal("session-token", result.SessionToken);
        Assert.Equal("linkedin", client.SessionIntegrationId);
    }

    [Fact]
    public async Task GetCredentialsAsync_WhenConnected_MapsLinkedInEnvelopeKeys()
    {
        var client = ConnectedClient();
        var broker = CreateBroker(client);

        var result = await broker.GetCredentialsAsync(
            "linkedin",
            Guid.NewGuid(),
            CancellationToken.None);

        Assert.NotNull(result);
        Assert.Equal("secret-access-token", result["linkedin.accessToken"]);
        Assert.Equal("urn:li:person:member-123", result["linkedin.authorUrn"]);
    }

    [Fact]
    public async Task GetCredentialsAsync_WhenGoogleConnected_MapsGoogleEnvelopeKeys()
    {
        var client = ConnectedClient();
        client.Credentials = new NangoOAuthCredentials(
            "google-secret-token",
            "google-subject",
            "owner@example.com");
        var broker = CreateBroker(client);

        var result = await broker.GetCredentialsAsync(
            "google",
            Guid.NewGuid(),
            CancellationToken.None);

        Assert.NotNull(result);
        Assert.Equal("google-secret-token", result["google.accessToken"]);
        Assert.Equal("owner@example.com", result["google.email"]);
        Assert.DoesNotContain("linkedin.authorUrn", result.Keys);
    }

    [Fact]
    public async Task GetCredentialsAsync_WhenGoogleEmailMissing_OmitsEmailKey()
    {
        var client = ConnectedClient();
        client.Credentials = new NangoOAuthCredentials("google-secret-token", null);
        var broker = CreateBroker(client);

        var result = await broker.GetCredentialsAsync(
            "google",
            Guid.NewGuid(),
            CancellationToken.None);

        Assert.NotNull(result);
        Assert.Equal("google-secret-token", result["google.accessToken"]);
        Assert.DoesNotContain("google.email", result.Keys);
    }

    [Fact]
    public async Task GetCredentialsAsync_WhenNotConnected_ReturnsNullForApiNotFound()
    {
        var broker = CreateBroker(new NangoClientStub());

        var result = await broker.GetCredentialsAsync(
            "linkedin",
            Guid.NewGuid(),
            CancellationToken.None);

        Assert.Null(result);
    }

    [Fact]
    public async Task DisconnectAsync_WhenConnected_RemovesMapping()
    {
        var client = ConnectedClient();
        var broker = CreateBroker(client);

        var result = await broker.DisconnectAsync(
            "linkedin",
            Guid.NewGuid(),
            CancellationToken.None);

        Assert.True(result);
        Assert.Equal("connection-1", client.DeletedConnectionId);
    }

    [Fact]
    public async Task GetCredentialsAsync_WhenConnected_NeverLogsAccessToken()
    {
        var logger = new CapturingLogger<NangoConnectorBroker>();
        var broker = CreateBroker(ConnectedClient(), logger);

        await broker.GetCredentialsAsync("linkedin", Guid.NewGuid(), CancellationToken.None);

        Assert.DoesNotContain("secret-access-token", string.Join(' ', logger.Messages));
    }

    private static NangoConnectorBroker CreateBroker(
        NangoClientStub client,
        ILogger<NangoConnectorBroker>? logger = null) => new(
        client,
        new LinkedInIdentityStub(),
        Options.Create(new NangoOptions
        {
            ApiKey = "nango-test-key",
            LinkedInIntegrationId = "linkedin",
            GoogleIntegrationId = "google"
        }),
        logger ?? new CapturingLogger<NangoConnectorBroker>());

    private static NangoClientStub ConnectedClient() => new()
    {
        Connections =
        [
            new NangoConnectionSummary(
                "connection-1",
                "linkedin",
                DateTimeOffset.UtcNow,
                true)
        ],
        Credentials = new NangoOAuthCredentials("secret-access-token", "member-123")
    };

    private sealed class NangoClientStub : INangoConnectorClient
    {
        public IReadOnlyList<NangoConnectionSummary> Connections { get; init; } = [];
        public NangoOAuthCredentials Credentials { get; set; } = new("token", "subject");
        public string? SessionIntegrationId { get; private set; }
        public string? DeletedConnectionId { get; private set; }

        public Task<NangoConnectSession> CreateSessionAsync(
            string integrationId,
            string deviceId,
            CancellationToken cancellationToken)
        {
            SessionIntegrationId = integrationId;
            return Task.FromResult(new NangoConnectSession(
                "https://connect.nango.dev/session",
                "session-token",
                DateTimeOffset.UtcNow.AddMinutes(30)));
        }

        public Task<IReadOnlyList<NangoConnectionSummary>> ListConnectionsAsync(
            string integrationId,
            string deviceId,
            CancellationToken cancellationToken) => Task.FromResult(Connections);

        public Task<NangoOAuthCredentials> GetCredentialsAsync(
            string integrationId,
            string connectionId,
            CancellationToken cancellationToken) => Task.FromResult(Credentials);

        public Task DeleteConnectionAsync(
            string integrationId,
            string connectionId,
            CancellationToken cancellationToken)
        {
            DeletedConnectionId = connectionId;
            return Task.CompletedTask;
        }
    }

    private sealed class LinkedInIdentityStub : ILinkedInIdentityClient
    {
        public Task<string> GetSubjectAsync(
            string accessToken,
            CancellationToken cancellationToken) => Task.FromResult("fallback-subject");
    }

    private sealed class CapturingLogger<T> : ILogger<T>
    {
        public List<string> Messages { get; } = [];
        public IDisposable? BeginScope<TState>(TState state) where TState : notnull => null;
        public bool IsEnabled(LogLevel logLevel) => true;
        public void Log<TState>(
            LogLevel logLevel,
            EventId eventId,
            TState state,
            Exception? exception,
            Func<TState, Exception?, string> formatter) =>
            Messages.Add(formatter(state, exception));
    }
}
