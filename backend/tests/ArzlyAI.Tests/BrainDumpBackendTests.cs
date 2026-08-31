using System.Net;
using System.Text.Json;
using ArzlyAI.Application.Integrations;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Application.Services.Workflows.Rendering;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Infrastructure.Persistence.Seeds;
using ArzlyAI.Infrastructure.Integrations.Google;

namespace ArzlyAI.Tests;

public sealed class BrainDumpBackendTests
{
    private const string Report = """
    {"schema":"arzly.report","version":4,"kind":"actionPlan","title":"Monday plan","summary":"Three quick wins and two projects","generatedAtUtc":"2026-08-31T08:00:00Z","blocks":[{"type":"quickWins","title":"Do now","data":{"text":"Fast tasks","items":[{"label":"Call mom","value":"2 min","detail":"Quick check-in"}],"metrics":[]}},{"type":"projects","title":"Projects","data":{"text":"Bigger work","items":[{"label":"Website","value":"2 hours","detail":"Review site\nCreate mockups"}],"metrics":[]}},{"type":"schedule","title":"Schedule","data":{"text":"Today","items":[{"label":"Quick wins","value":"09:00","detail":"Morning block"}],"metrics":[]}}],"sources":[]}
    """;

    [Fact]
    public void CreatePreset_UsesPublishedGraphWithReviewAndConditionalIntegrations()
    {
        var preset = CreatePreset();

        Assert.Equal(BrainDumpToActionPresetSeed.TargetVersion, preset.Version);
        Assert.Equal(("arzly.report", 4), (preset.ResultContractKey, preset.ResultContractVersion));
        Assert.Equal(6, preset.Workflow.Steps.Count);
        Assert.Equal(3, preset.Integrations.Count);
        Assert.Contains(preset.Workflow.Steps,
            step => step.Type == WorkflowNodeType.HumanApproval && step.ReferenceKey == "review-plan");
        Assert.Contains(preset.Workflow.Steps,
            step => step.ReferenceKey == "google.tasks.create");
    }

    [Fact]
    public async Task IntegrationHandler_WhenSyncDisabled_SkipsBeforeCredentials()
    {
        var integration = new RecordingIntegration("google.tasks.create");
        var handler = new IntegrationWorkflowNodeHandler([integration]);
        var context = Context("false", integration.Key);

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(WorkflowNodeStatus.Skipped, result.Status);
        Assert.Equal(0, integration.Executions);
    }

    [Fact]
    public async Task IntegrationHandler_WhenSyncEnabled_ExecutesWithCredentials()
    {
        var integration = new RecordingIntegration("google.tasks.create");
        var handler = new IntegrationWorkflowNodeHandler([integration]);
        var context = Context("true", integration.Key);

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(WorkflowNodeStatus.Completed, result.Status);
        Assert.Equal(1, integration.Executions);
    }

    [Fact]
    public void Render_WhenActionPlan_RendersActionPlanIdentity()
    {
        using var document = JsonDocument.Parse(Report);
        var html = new ArzlyReportHtmlRenderer().Render(document.RootElement);
        Assert.Contains("Action Plan", html, StringComparison.Ordinal);
        Assert.Contains("Monday plan", html, StringComparison.Ordinal);
        Assert.Contains("Call mom", html, StringComparison.Ordinal);
    }

    [Fact]
    public void Projection_WhenActionPlan_ExtractsTasksAndEvents()
    {
        var tasks = ActionPlanProjection.ToTasks(Report);
        var events = ActionPlanProjection.ToEvents(Report, "2026-08-31", "09:00", "17:00");
        Assert.Equal(2, tasks.Count);
        Assert.Single(events);
        Assert.Equal("Website", tasks[1].Title);
        Assert.Equal(2, tasks[1].Subtasks.Count);
    }

    [Fact]
    public async Task TasksClient_WhenGoogleResponds_CreatesTasksWithoutLoggingSecrets()
    {
        var handler = new RecordingHandler();
        handler.Enqueue(HttpStatusCode.OK, """{"items":[{"id":"list-1","title":"ArzlyAI"}]}""");
        handler.Enqueue(HttpStatusCode.OK, """{"id":"task-1"}""");
        handler.Enqueue(HttpStatusCode.OK, """{"id":"task-2"}""");
        handler.Enqueue(HttpStatusCode.OK, """{"id":"task-3"}""");
        handler.Enqueue(HttpStatusCode.OK, """{"id":"task-4"}""");
        handler.Enqueue(HttpStatusCode.OK, """{"id":"task-5"}""");
        var logger = new CapturingLogger<GoogleTasksClient>();
        var client = new GoogleTasksClient(new HttpClient(handler), logger);

        var result = await client.SyncActionPlanAsync(
            Report,
            "ArzlyAI",
            "secret-google-token",
            CancellationToken.None);

        using var payload = JsonDocument.Parse(result);
        Assert.Equal("list-1", payload.RootElement.GetProperty("taskListId").GetString());
        Assert.Equal(4, payload.RootElement.GetProperty("created").GetInt32());
        Assert.DoesNotContain("secret-google-token", string.Join(' ', logger.Messages));
    }

    private static PresetDefinition CreatePreset()
    {
        var provider = new ProviderDefinition
        {
            Id = Guid.NewGuid(),
            Key = "openai",
            DisplayName = "OpenAI"
        };
        var model = new ModelDefinition
        {
            Id = Guid.NewGuid(),
            ProviderId = provider.Id,
            Provider = provider,
            Key = "gpt-5-mini",
            DisplayName = "GPT-5 mini"
        };
        var integrations = new[] { "google.tasks.create", "google.calendar.create-events", "google.gmail.send-html" }
            .Select((key, index) => new IntegrationDefinition
            {
                Id = Guid.Parse($"00000000-0000-0000-0000-{(index + 1).ToString().PadLeft(12, '0')}"),
                Key = key,
                DisplayName = key,
                Description = key,
                CredentialSchemaJson = "{}",
                IsEnabled = true
            }).ToDictionary(item => item.Key, StringComparer.Ordinal);
        return BrainDumpToActionPresetSeed.CreatePreset(model, integrations);
    }

    private static WorkflowNodeExecutionContext Context(string syncFlag, string key) =>
        new(
            CreatePreset(),
            CreatePreset().Workflow.Steps.Single(step => step.ReferenceKey == key),
            new WorkflowRun { Id = Guid.NewGuid(), PresetKey = BrainDumpToActionPresetSeed.PresetKey },
            new Dictionary<string, string>
            {
                ["syncTasks"] = syncFlag,
                ["syncCalendar"] = syncFlag,
                ["sendEmail"] = syncFlag,
                ["reportJson"] = Report,
                ["asOfDate"] = "2026-08-31",
                ["workingHoursStart"] = "09:00",
                ["workingHoursEnd"] = "17:00",
                ["recipient"] = "person@example.com",
                ["subject"] = "Plan"
            },
            new Dictionary<string, string> { ["google.accessToken"] = "token" },
            null);

    private sealed class RecordingIntegration(string key) : IIntegrationHandler
    {
        public string Key => key;
        public int Executions { get; private set; }

        public Task<string> ExecuteAsync(
            IReadOnlyDictionary<string, string> inputs,
            IReadOnlyDictionary<string, string> credentials,
            CancellationToken cancellationToken)
        {
            Executions++;
            return Task.FromResult("synced");
        }
    }

    private sealed class RecordingHandler : HttpMessageHandler
    {
        private readonly Queue<HttpResponseMessage> responses = new();
        public void Enqueue(HttpStatusCode statusCode, string body) =>
            responses.Enqueue(new HttpResponseMessage(statusCode)
            {
                Content = new StringContent(body, System.Text.Encoding.UTF8, "application/json")
            });

        protected override Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken) =>
            Task.FromResult(responses.Dequeue());
    }

    private sealed class CapturingLogger<T> : Microsoft.Extensions.Logging.ILogger<T>
    {
        public List<string> Messages { get; } = [];
        public IDisposable? BeginScope<TState>(TState state) where TState : notnull => null;
        public bool IsEnabled(Microsoft.Extensions.Logging.LogLevel logLevel) => true;
        public void Log<TState>(
            Microsoft.Extensions.Logging.LogLevel logLevel,
            Microsoft.Extensions.Logging.EventId eventId,
            TState state,
            Exception? exception,
            Func<TState, Exception?, string> formatter) =>
            Messages.Add(formatter(state, exception));
    }
}
