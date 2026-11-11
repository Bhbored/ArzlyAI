using System.Text.Json;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Infrastructure.Agents.Authoring;

namespace ArzlyAI.Tests;

public sealed class PresetAuthoringToolExecutorTests
{
    [Fact]
    public async Task ExecuteAsync_WhenKnownToolInputIsEmpty_ReturnsRecoverableToolError()
    {
        var toolbox = new StubToolbox();
        var executor = new PresetAuthoringToolExecutor(toolbox, new StubRealtimeNotifier());
        using var argumentsDocument = JsonDocument.Parse("{}");

        var result = await executor.ExecuteAsync(
            Guid.NewGuid(),
            "save_preset_draft",
            argumentsDocument.RootElement.Clone(),
            CancellationToken.None);

        using var resultDocument = JsonDocument.Parse(result);
        Assert.True(resultDocument.RootElement.TryGetProperty("error", out var error));
        Assert.Contains("draftJson", error.GetString(), StringComparison.Ordinal);
        Assert.Equal(1, toolbox.RecordedResults);
        Assert.False(toolbox.SaveDraftCalled);
    }

    private sealed class StubToolbox : IPresetAuthoringToolbox
    {
        public int RecordedResults { get; private set; }
        public bool SaveDraftCalled { get; private set; }

        public Task<string> ListCapabilitiesAsync(CancellationToken cancellationToken) =>
            Task.FromResult("{}");

        public Task<string> GetCapabilityDetailsAsync(string key, CancellationToken cancellationToken) =>
            Task.FromResult("{}");

        public Task<string> SaveDraftAsync(
            Guid sessionId, string draftJson, CancellationToken cancellationToken)
        {
            SaveDraftCalled = true;
            return Task.FromResult("{}");
        }

        public Task<string> ValidateDraftAsync(Guid sessionId, CancellationToken cancellationToken) =>
            Task.FromResult("{}");

        public Task RecordToolResultAsync(
            Guid sessionId, string toolName, string resultJson, CancellationToken cancellationToken)
        {
            RecordedResults++;
            return Task.CompletedTask;
        }
    }

    private sealed class StubRealtimeNotifier : IAuthoringRealtimeNotifier
    {
        public Task NotifyAsync(
            Guid sessionId, string eventName, object payload, CancellationToken cancellationToken) =>
            Task.CompletedTask;
    }
}
