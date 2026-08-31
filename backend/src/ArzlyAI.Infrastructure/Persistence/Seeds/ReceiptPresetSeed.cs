using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Seeds;

public static class ReceiptPresetSeed
{
    public const string PresetKey = "receipt-intelligence";
    public const int TargetVersion = 1;
    public static readonly string[] LegacyPresetKeys =
    [
        "receipt-monthly-spending",
        "receipt-weekly-budget",
        "receipt-quarterly-tax",
        "receipt-yearly-review",
        "receipt-category-dive",
        "receipt-anomaly-detector",
        "receipt-savings-tracker"
    ];

    public static async Task SeedAsync(ArzlyDbContext dbContext, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ReceiptPresetSeed.Seed");
        var integrations = await EnsureIntegrationsAsync(dbContext, cancellationToken);
        var model = await dbContext.Models.Include(item => item.Provider)
            .SingleAsync(item => item.Provider.Key == "openai" && item.Key == "gpt-5-mini",
                cancellationToken);

        var currentPreset = await dbContext.Presets
            .Where(preset => preset.Key == PresetKey)
            .OrderByDescending(preset => preset.Version)
            .FirstOrDefaultAsync(cancellationToken);
        if (currentPreset is null)
        {
            dbContext.Add(CreatePreset(model, integrations));
            await dbContext.SaveChangesAsync(cancellationToken);
        }
        else if (currentPreset.Version < TargetVersion)
        {
            throw new InvalidOperationException(
                $"Preset '{PresetKey}' requires an explicit version upgrade.");
        }

        await dbContext.Presets
            .Where(preset => LegacyPresetKeys.Contains(preset.Key) && preset.IsPublished)
            .ExecuteUpdateAsync(
                setters => setters.SetProperty(preset => preset.IsPublished, false),
                cancellationToken);
    }

    public static PresetDefinition CreatePreset(
        ModelDefinition model,
        IReadOnlyDictionary<string, IntegrationDefinition> integrations)
    {
        foreach (var integrationKey in RequiredIntegrationKeys)
            if (!integrations.ContainsKey(integrationKey))
                throw new ArgumentException($"Integration '{integrationKey}' is required.",
                    nameof(integrations));

        Guid Id(int suffix) => Guid.Parse(
            $"00000000-0000-0000-0004-{suffix.ToString().PadLeft(12, '0')}");

        var preset = new PresetDefinition
        {
            Id = Id(0),
            Key = PresetKey,
            Name = "Receipt Intelligence",
            Description = "Turn a receipt sheet into the spending insight you need, from budgets and taxes to trends and anomalies.",
            Version = TargetVersion,
            IsPublished = true,
            InputSchemaJson = InputSchema,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4
        };
        var reportAgent = new AgentDefinition
        {
            Id = Id(1),
            PresetId = preset.Id,
            ModelId = model.Id,
            Key = "receipt-report-writer",
            Name = "Receipt Report Writer",
            Instructions = ReportInstructions,
            OutputSchemaJson = ReportSchema,
            RuntimeType = AgentRuntimeType.Model,
            DefaultTemperature = 0.2,
            MinimumTemperature = 0,
            MaximumTemperature = 1,
            AllowModelOverride = true,
            AllowTemperatureOverride = true,
            Preset = preset,
            Model = model
        };
        reportAgent.Harness = new AgentHarnessDefinition
        {
            Id = Id(2),
            AgentId = reportAgent.Id,
            Agent = reportAgent,
            PlanningEnabled = false,
            TodoTrackingEnabled = false,
            ContextCompactionEnabled = true,
            RequireToolApproval = false,
            MaxIterations = 3
        };
        var finalAgent = new AgentDefinition
        {
            Id = Id(3),
            PresetId = preset.Id,
            ModelId = model.Id,
            Key = "receipt-report-result",
            Name = "Receipt Report",
            Instructions = "Return the completed report unchanged.",
            RuntimeType = AgentRuntimeType.Passthrough,
            DefaultTemperature = 0,
            MinimumTemperature = 0,
            MaximumTemperature = 0,
            AllowModelOverride = false,
            AllowTemperatureOverride = false,
            Preset = preset,
            Model = model
        };
        finalAgent.Harness = new AgentHarnessDefinition
        {
            Id = Id(4),
            AgentId = finalAgent.Id,
            Agent = finalAgent,
            ContextCompactionEnabled = false,
            MaxIterations = 1
        };
        preset.Agents.Add(reportAgent);
        preset.Agents.Add(finalAgent);

        var workflow = new WorkflowDefinition
        {
            Id = Id(10),
            PresetId = preset.Id,
            Key = "analyze-and-deliver",
            Preset = preset
        };
        preset.Workflow = workflow;
        var steps = new[]
        {
            Step(Id(11), workflow, 1, WorkflowNodeType.Integration, "google.sheets.read",
                "Read receipt sheet",
                """{"spreadsheetId":"$.inputs.spreadsheetId","range":"$.inputs.sourceRange","maximumRows":"$.literal.1000"}"""),
            Step(Id(12), workflow, 2, WorkflowNodeType.Operation, "receipt.analyze",
                "Normalize and analyze receipts",
                """{"rowsJson":"$.steps[0].output","analysisMode":"$.inputs.analysisMode","columnMappingJson":"$.inputs.columnMappingJson","asOfDate":"$.inputs.asOfDate?","currencyCode":"$.inputs.currencyCode","budget":"$.inputs.budget?","taxRate":"$.inputs.taxRate?","category":"$.inputs.category?"}"""),
            Step(Id(13), workflow, 3, WorkflowNodeType.Agent, reportAgent.Key,
                reportAgent.Name, """{"analysis":"$.steps[1].output"}"""),
            Step(Id(14), workflow, 4, WorkflowNodeType.Integration, "google.sheets.report",
                "Write report sheet",
                """{"deliveryMode":"$.inputs.deliveryMode?","spreadsheetId":"$.inputs.spreadsheetId","tabTitle":"$.inputs.reportTabTitle?","reportJson":"$.steps[2].output"}""",
                """{"when":{"input":"deliveryMode","equalsAny":["sheets","both"]}}"""),
            Step(Id(15), workflow, 5, WorkflowNodeType.Integration, "google.gmail.send-html",
                "Email receipt report",
                """{"deliveryMode":"$.inputs.deliveryMode?","recipient":"$.inputs.recipientEmail?","subject":"$.literal.Your receipt intelligence report","reportJson":"$.steps[2].output"}""",
                """{"when":{"input":"deliveryMode","equalsAny":["email","both"]}}"""),
            Step(Id(16), workflow, 6, WorkflowNodeType.Agent, finalAgent.Key,
                finalAgent.Name, """{"report":"$.steps[2].output"}""", contractKey: "arzly.report",
                contractVersion: 4)
        };
        foreach (var step in steps) workflow.Steps.Add(step);
        for (var index = 0; index < steps.Length - 1; index++)
            workflow.Connections.Add(new WorkflowConnectionDefinition
            {
                Id = Id(20 + index),
                WorkflowId = workflow.Id,
                SourceStepId = steps[index].Id,
                TargetStepId = steps[index + 1].Id,
                Workflow = workflow
            });

        foreach (var integrationKey in RequiredIntegrationKeys)
            preset.Integrations.Add(new PresetIntegration
            {
                PresetId = preset.Id,
                IntegrationId = integrations[integrationKey].Id,
                Preset = preset,
                Integration = integrations[integrationKey]
            });
        return preset;
    }

    private static WorkflowStepDefinition Step(
        Guid id,
        WorkflowDefinition workflow,
        int position,
        WorkflowNodeType type,
        string key,
        string name,
        string mapping,
        string? configuration = null,
        string? contractKey = null,
        int? contractVersion = null) => new()
        {
            Id = id,
            WorkflowId = workflow.Id,
            Workflow = workflow,
            Position = position,
            Type = type,
            ReferenceKey = key,
            DisplayName = name,
            InputMappingJson = mapping,
            ConfigurationJson = configuration,
            ResultContractKey = contractKey,
            ResultContractVersion = contractVersion
        };

    private static readonly string[] RequiredIntegrationKeys =
        ["google.sheets.read", "google.sheets.report", "google.gmail.send-html"];

    private static async Task<IReadOnlyDictionary<string, IntegrationDefinition>>
        EnsureIntegrationsAsync(ArzlyDbContext dbContext, CancellationToken cancellationToken)
    {
        var definitions = new[]
        {
            Integration("1901", "google.sheets.read", "Google Sheets Read",
                "Read a bounded range from Google Sheets."),
            Integration("1902", "google.sheets.report", "Google Sheets Report",
                "Write a formatted report tab to Google Sheets."),
            Integration("1903", "google.gmail.send-html", "Gmail HTML",
                "Send an HTML report with Gmail.")
        };
        foreach (var definition in definitions)
            if (!await dbContext.Integrations.AnyAsync(
                    item => item.Key == definition.Key, cancellationToken))
                dbContext.Integrations.Add(definition);
        await dbContext.SaveChangesAsync(cancellationToken);
        return await dbContext.Integrations.Where(item => RequiredIntegrationKeys.Contains(item.Key))
            .ToDictionaryAsync(item => item.Key, StringComparer.Ordinal, cancellationToken);
    }

    private static IntegrationDefinition Integration(
        string suffix,
        string key,
        string name,
        string description) => new()
        {
            Id = Guid.Parse($"00000000-0000-0000-0002-{suffix.PadLeft(12, '0')}"),
            Key = key,
            DisplayName = name,
            Description = description,
            IsEnabled = true,
            CredentialSchemaJson = key == "google.gmail.send-html"
                ? """{"type":"oauth2AccessToken","fields":["google.accessToken","google.email"]}"""
                : """{"type":"oauth2AccessToken","fields":["google.accessToken"]}"""
        };

    private const string ReportInstructions =
        "Create an arzly.report version 4 financeReport document using only the deterministic receipt " +
        "analysis supplied. Preserve all amounts and the currency code exactly. Explain useful patterns " +
        "without inventing transactions, tax advice, or savings. Use financeSummary, categoryBreakdown, " +
        "merchantBreakdown, budgetStatus, anomalyCallout, taxEstimate, trend and nextSteps blocks as " +
        "appropriate. Each block data object must contain text, items and metrics. Items use label, value " +
        "and detail. Metrics use label, value and maximum. Sources must be empty because the private sheet " +
        "is not a public citation. Never output receipt rows, credentials, markdown, or HTML. Return only JSON.";

    private const string InputSchema = """
{"version":2,"presentation":{"layout":"guided","primaryField":"analysisMode"},"fields":[{"key":"analysisMode","label":"What do you want to learn?","type":"selectCards","required":true,"defaultValue":"monthly-spending","options":[{"value":"monthly-spending","label":"Monthly snapshot","description":"See where this month's money went.","iconKey":"calendar-month"},{"value":"weekly-budget","label":"Weekly budget","description":"Compare this week with your spending limit.","iconKey":"wallet","requiresFields":["budget"]},{"value":"quarterly-tax","label":"Quarterly tax view","description":"Organize quarterly totals and estimate tax.","iconKey":"receipt-tax","requiresFields":["taxRate"]},{"value":"yearly-review","label":"Year in review","description":"Spot spending patterns across the year.","iconKey":"chart-trend"},{"value":"category-dive","label":"Category deep dive","description":"Focus on one spending category.","iconKey":"tag","requiresFields":["category"]},{"value":"anomaly-detector","label":"Unusual spending","description":"Find amounts that stand out from the norm.","iconKey":"alert-circle"},{"value":"savings-tracker","label":"Savings tracker","description":"Measure spending against a savings budget.","iconKey":"piggy-bank","requiresFields":["budget"]}]},{"key":"spreadsheetId","label":"Receipt spreadsheet","type":"text","required":true},{"key":"sourceRange","label":"Receipt range","type":"text","required":true},{"key":"columnMappingJson","label":"Column mapping","type":"multilineText","required":true,"maxLength":2000},{"key":"asOfDate","label":"Report date","type":"date","required":true},{"key":"currencyCode","label":"Currency","type":"currency","required":true},{"key":"budget","label":"Budget","type":"decimal","required":false,"minimum":0,"visibleWhen":{"field":"analysisMode","equalsAny":["weekly-budget","savings-tracker"]}},{"key":"taxRate","label":"Tax rate","type":"decimal","required":false,"minimum":0,"maximum":1,"visibleWhen":{"field":"analysisMode","equalsAny":["quarterly-tax"]}},{"key":"category","label":"Category","type":"text","required":false,"visibleWhen":{"field":"analysisMode","equalsAny":["category-dive"]}},{"key":"deliveryMode","label":"Delivery","type":"select","required":false,"defaultValue":"preview","options":[{"value":"preview","label":"Preview only"},{"value":"sheets","label":"Google Sheets"},{"value":"email","label":"Email"},{"value":"both","label":"Sheets and email"}]},{"key":"reportTabTitle","label":"Report tab","type":"text","required":false,"visibleWhen":{"field":"deliveryMode","equalsAny":["sheets","both"]}},{"key":"recipientEmail","label":"Recipient email","type":"email","required":false,"visibleWhen":{"field":"deliveryMode","equalsAny":["email","both"]}}]}
""";

    private const string ReportSchema = """
{"type":"object","additionalProperties":false,"properties":{"schema":{"type":"string","const":"arzly.report"},"version":{"type":"integer","const":4},"kind":{"type":"string","const":"financeReport"},"title":{"type":"string"},"summary":{"type":"string"},"generatedAtUtc":{"type":"string"},"blocks":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"type":{"type":"string","enum":["financeSummary","categoryBreakdown","merchantBreakdown","budgetStatus","anomalyCallout","taxEstimate","trend","nextSteps"]},"title":{"type":"string"},"data":{"type":"object","additionalProperties":false,"properties":{"text":{"type":"string"},"items":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"label":{"type":"string"},"value":{"type":"string"},"detail":{"type":"string"}},"required":["label","value","detail"]}},"metrics":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"label":{"type":"string"},"value":{"type":"number"},"maximum":{"type":"number"}},"required":["label","value","maximum"]}}},"required":["text","items","metrics"]}},"required":["type","title","data"]}},"sources":{"type":"array","maxItems":0}},"required":["schema","version","kind","title","summary","generatedAtUtc","blocks","sources"]}
""";
}
