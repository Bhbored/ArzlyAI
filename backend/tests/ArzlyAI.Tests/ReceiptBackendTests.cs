using System.Text.Json;
using ArzlyAI.Application.Integrations;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Application.Services.Workflows.Operations;
using ArzlyAI.Application.Services.Workflows.Rendering;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Infrastructure.Persistence.Seeds;

namespace ArzlyAI.Tests;

public sealed class ReceiptBackendTests
{
    private const string Rows = """
    [["Date","Amount","Category","Merchant"],["2026-01-05","10.00","Food","Cafe"],["2026-01-12","20.00","Travel","Metro"],["2026-01-15","30.00","Food","Market"],["2026-02-01","40.00","Home","Store"],["2026-04-01","50.00","Food","Market"]]
    """;
    private const string Mapping =
        """{"date":"Date","amount":"Amount","category":"Category","merchant":"Merchant"}""";

    [Theory]
    [InlineData("monthly-spending", "categories", 60)]
    [InlineData("weekly-budget", "remaining", 50)]
    [InlineData("quarterly-tax", "estimatedTax", 60)]
    [InlineData("yearly-review", "monthlyTotals", 60)]
    [InlineData("category-dive", "category", 40)]
    [InlineData("anomaly-detector", "anomalies", 60)]
    [InlineData("savings-tracker", "potentialSavings", 60)]
    public async Task ExecuteAsync_WhenModeSupported_ProducesDeterministicAnalysis(
        string mode,
        string modeProperty,
        int expectedTotal)
    {
        var inputs = Inputs(mode);

        var first = await new ReceiptAnalysisOperation().ExecuteAsync(inputs, CancellationToken.None);
        var second = await new ReceiptAnalysisOperation().ExecuteAsync(inputs, CancellationToken.None);

        Assert.Equal(first, second);
        using var document = JsonDocument.Parse(first);
        Assert.Equal(mode, document.RootElement.GetProperty("analysisMode").GetString());
        Assert.Equal("USD", document.RootElement.GetProperty("currencyCode").GetString());
        Assert.Equal(expectedTotal, document.RootElement.GetProperty("total").GetDecimal());
        Assert.True(document.RootElement.TryGetProperty(modeProperty, out _));
        Assert.DoesNotContain("rowsJson", first, StringComparison.Ordinal);
    }

    [Theory]
    [InlineData("""[["Date","Amount","Category","Merchant"],["01/15/2026","10","Food","Cafe"]]""",
        "invalid date")]
    [InlineData("""[["Date","Amount","Category","Merchant"],["2026-01-15","$10","Food","Cafe"]]""",
        "invalid amount")]
    [InlineData("""[["Date","Amount","Category","Merchant"],["2026-01-15","10","","Cafe"]]""",
        "category")]
    public async Task ExecuteAsync_WhenRowsMalformed_RejectsEntireInput(string rows, string message)
    {
        var inputs = Inputs("monthly-spending");
        inputs["rowsJson"] = rows;

        var exception = await Assert.ThrowsAsync<ArgumentException>(() =>
            new ReceiptAnalysisOperation().ExecuteAsync(inputs, CancellationToken.None));

        Assert.Contains(message, exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task ExecuteAsync_WhenRowsExceedBound_RejectsInput()
    {
        var rows = new List<string> { """["Date","Amount","Category","Merchant"]""" };
        rows.AddRange(Enumerable.Range(0, ReceiptAnalysisOperation.MaximumReceiptRows + 1)
            .Select(_ => """["2026-01-15","1","Food","Cafe"]"""));
        var inputs = Inputs("monthly-spending");
        inputs["rowsJson"] = $"[{string.Join(',', rows)}]";

        var exception = await Assert.ThrowsAsync<ArgumentException>(() =>
            new ReceiptAnalysisOperation().ExecuteAsync(inputs, CancellationToken.None));

        Assert.Contains("row limit", exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void CreatePreset_UsesOnePublishedConfigurableGraph()
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
        var integrations = new[] { "google.sheets.read", "google.sheets.report", "google.gmail.send-html" }
            .Select((key, index) => new IntegrationDefinition
            {
                Id = Guid.Parse($"00000000-0000-0000-0000-{(index + 1).ToString().PadLeft(12, '0')}"),
                Key = key,
                DisplayName = key,
                Description = key,
                CredentialSchemaJson = "{}",
                IsEnabled = true
            }).ToDictionary(item => item.Key, StringComparer.Ordinal);

        var preset = ReceiptPresetSeed.CreatePreset(model, integrations);

        Assert.Equal(ReceiptPresetSeed.PresetKey, preset.Key);
        Assert.Equal(7, ReceiptPresetSeed.LegacyPresetKeys.Length);
        Assert.True(preset.IsPublished);
        Assert.Equal(ReceiptPresetSeed.TargetVersion, preset.Version);
        Assert.Equal(("arzly.report", 4), (preset.ResultContractKey, preset.ResultContractVersion));
        Assert.Equal(6, preset.Workflow.Steps.Count);
        Assert.Equal(5, preset.Workflow.Connections.Count);
        Assert.Equal(3, preset.Integrations.Count);
        var analysisStep = Assert.Single(preset.Workflow.Steps,
            step => step.ReferenceKey == ReceiptAnalysisOperation.OperationKey);
        Assert.Contains("$.inputs.analysisMode", analysisStep.InputMappingJson,
            StringComparison.Ordinal);
        Assert.Equal("receipt-report-result",
            preset.Workflow.Steps.OrderBy(step => step.Position).Last().ReferenceKey);

        using var schema = JsonDocument.Parse(preset.InputSchemaJson!);
        Assert.Equal(2, schema.RootElement.GetProperty("version").GetInt32());
        var modeField = schema.RootElement.GetProperty("fields").EnumerateArray()
            .Single(field => field.GetProperty("key").GetString() == "analysisMode");
        Assert.Equal("selectCards", modeField.GetProperty("type").GetString());
        Assert.Equal(7, modeField.GetProperty("options").GetArrayLength());

        var recreated = ReceiptPresetSeed.CreatePreset(model, integrations);
        Assert.Equal(preset.Id, recreated.Id);
        Assert.Equal(
            preset.Workflow.Steps.OrderBy(step => step.Position).Select(step => step.Id),
            recreated.Workflow.Steps.OrderBy(step => step.Position).Select(step => step.Id));
    }

    [Fact]
    public async Task IntegrationHandler_WhenDeliveryModePreview_SkipsBeforeCredentials()
    {
        var integration = new RecordingIntegration();
        var handler = new IntegrationWorkflowNodeHandler([integration]);
        var context = Context("preview", integration.Key);

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(WorkflowNodeStatus.Skipped, result.Status);
        Assert.Equal(0, integration.Executions);
    }

    [Fact]
    public async Task IntegrationHandler_WhenDeliveryModeMatches_ExecutesWithCredentials()
    {
        var integration = new RecordingIntegration();
        var handler = new IntegrationWorkflowNodeHandler([integration]);
        var context = Context("both", integration.Key);

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(WorkflowNodeStatus.Completed, result.Status);
        Assert.Equal(1, integration.Executions);
        Assert.Equal("token", integration.Credential);
    }

    [Fact]
    public void Render_WhenFinanceReport_RendersFinanceIdentityAndEscapesPrivateValues()
    {
        using var document = JsonDocument.Parse("""
        {"schema":"arzly.report","version":4,"kind":"financeReport","title":"January <Report>","summary":"Private summary","generatedAtUtc":"2026-01-31T00:00:00Z","blocks":[{"type":"financeSummary","title":"Spending","data":{"text":"Total","items":[{"label":"Food","value":"USD 40","detail":"Two receipts"}],"metrics":[]}}],"sources":[]}
        """);

        var renderer = new ArzlyReportHtmlRenderer();
        var html = renderer.Render(document.RootElement);

        Assert.True(renderer.CanRender("arzly.report", 4));
        Assert.Contains("Receipt Intelligence", html, StringComparison.Ordinal);
        Assert.Contains("January &lt;Report&gt;", html, StringComparison.Ordinal);
        Assert.Contains("USD 40", html, StringComparison.Ordinal);
    }

    private static Dictionary<string, string> Inputs(string mode) => new(StringComparer.Ordinal)
    {
        ["rowsJson"] = Rows,
        ["analysisMode"] = mode,
        ["columnMappingJson"] = Mapping,
        ["asOfDate"] = "2026-01-15",
        ["currencyCode"] = "usd",
        ["budget"] = "100",
        ["taxRate"] = "0.10",
        ["category"] = "Food"
    };

    private static WorkflowNodeExecutionContext Context(string mode, string key)
    {
        var preset = new PresetDefinition
        {
            Id = Guid.NewGuid(),
            Key = "receipt",
            Name = "Receipt",
            Description = "Receipt",
            Version = 1,
            IsPublished = true
        };
        var workflow = new WorkflowDefinition
        {
            Id = Guid.NewGuid(),
            PresetId = preset.Id,
            Preset = preset,
            Key = "flow"
        };
        preset.Workflow = workflow;
        var step = new WorkflowStepDefinition
        {
            Id = Guid.NewGuid(),
            WorkflowId = workflow.Id,
            Workflow = workflow,
            Position = 1,
            Type = WorkflowNodeType.Integration,
            ReferenceKey = key,
            DisplayName = "Deliver",
            InputMappingJson = "{}",
            ConfigurationJson =
                """{"when":{"input":"deliveryMode","equalsAny":["sheets","both"]}}"""
        };
        return new WorkflowNodeExecutionContext(
            preset,
            step,
            new WorkflowRun { Id = Guid.NewGuid(), PresetKey = preset.Key },
            new Dictionary<string, string> { ["deliveryMode"] = mode },
            new Dictionary<string, string> { ["google.accessToken"] = "token" },
            null);
    }

    private sealed class RecordingIntegration : IIntegrationHandler
    {
        public string Key => "google.sheets.report";
        public int Executions { get; private set; }
        public string? Credential { get; private set; }

        public Task<string> ExecuteAsync(
            IReadOnlyDictionary<string, string> inputs,
            IReadOnlyDictionary<string, string> credentials,
            CancellationToken cancellationToken)
        {
            Executions++;
            Credential = credentials["google.accessToken"];
            return Task.FromResult("delivered");
        }
    }
}
