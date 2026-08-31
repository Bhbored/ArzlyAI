using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Seeds;

public static class BrainDumpToActionPresetSeed
{
    public const string PresetKey = "brain-dump-to-action";
    public const int TargetVersion = 1;

    public static async Task SeedAsync(ArzlyDbContext dbContext, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("BrainDumpToActionPresetSeed.Seed");
        if (await dbContext.Presets.AnyAsync(
                preset => preset.Key == PresetKey && preset.Version >= TargetVersion,
                cancellationToken))
            return;
        if (await dbContext.Presets.AnyAsync(preset => preset.Key == PresetKey, cancellationToken))
            throw new InvalidOperationException(
                $"Preset '{PresetKey}' requires an explicit version upgrade.");

        var integrations = await EnsureIntegrationsAsync(dbContext, cancellationToken);
        var model = await dbContext.Models.Include(item => item.Provider)
            .SingleAsync(item => item.Provider.Key == "openai" && item.Key == "gpt-5-mini",
                cancellationToken);
        dbContext.Add(CreatePreset(model, integrations));
        await dbContext.SaveChangesAsync(cancellationToken);
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
            $"00000000-0000-0000-0003-{suffix.ToString().PadLeft(12, '0')}");

        var preset = new PresetDefinition
        {
            Id = Id(0),
            Key = PresetKey,
            Name = "Brain Dump to Action",
            Description = "Turn scattered thoughts into a structured action plan and optional Google sync.",
            Version = TargetVersion,
            IsPublished = true,
            InputSchemaJson = InputSchema,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4
        };

        var planner = new AgentDefinition
        {
            Id = Id(1),
            PresetId = preset.Id,
            ModelId = model.Id,
            Key = "plan-compiler",
            Name = "Plan Compiler",
            Instructions = PlannerInstructions,
            OutputSchemaJson = ReportSchema,
            RuntimeType = AgentRuntimeType.Model,
            DefaultTemperature = 0.3,
            MinimumTemperature = 0,
            MaximumTemperature = 1,
            AllowModelOverride = true,
            AllowTemperatureOverride = true,
            Preset = preset,
            Model = model
        };
        planner.Harness = new AgentHarnessDefinition
        {
            Id = Id(2),
            AgentId = planner.Id,
            Agent = planner,
            PlanningEnabled = false,
            TodoTrackingEnabled = false,
            ContextCompactionEnabled = true,
            RequireToolApproval = false,
            MaxIterations = 3
        };

        var resultAgent = new AgentDefinition
        {
            Id = Id(3),
            PresetId = preset.Id,
            ModelId = model.Id,
            Key = "plan-result",
            Name = "Action Plan",
            Instructions = "Return the completed action plan unchanged.",
            RuntimeType = AgentRuntimeType.Passthrough,
            DefaultTemperature = 0,
            MinimumTemperature = 0,
            MaximumTemperature = 0,
            AllowModelOverride = false,
            AllowTemperatureOverride = false,
            Preset = preset,
            Model = model
        };
        resultAgent.Harness = new AgentHarnessDefinition
        {
            Id = Id(4),
            AgentId = resultAgent.Id,
            Agent = resultAgent,
            ContextCompactionEnabled = false,
            MaxIterations = 1
        };
        preset.Agents.Add(planner);
        preset.Agents.Add(resultAgent);

        var workflow = new WorkflowDefinition
        {
            Id = Id(10),
            PresetId = preset.Id,
            Key = "compile-and-sync",
            Preset = preset
        };
        preset.Workflow = workflow;

        var steps = new[]
        {
            Step(Id(11), workflow, 1, WorkflowNodeType.Agent, planner.Key, planner.Name,
                """{"brainDump":"$.inputs.brainDump","asOfDate":"$.inputs.asOfDate","workingHoursStart":"$.inputs.workingHoursStart","workingHoursEnd":"$.inputs.workingHoursEnd","energyPreference":"$.inputs.energyPreference?"}"""),
            Step(Id(12), workflow, 2, WorkflowNodeType.HumanApproval, "review-plan", "Review plan",
                """{"content":"$.steps[0].output"}""", ReviewApproval, contractKey: "arzly.report", contractVersion: 4),
            Step(Id(13), workflow, 3, WorkflowNodeType.Integration, "google.tasks.create",
                "Sync Google Tasks",
                """{"syncTasks":"$.inputs.syncTasks?","reportJson":"$.steps[1].approvedOutput","taskListTitle":"$.inputs.taskListTitle?"}""",
                """{"when":{"input":"syncTasks","equalsAny":["true"]}}"""),
            Step(Id(14), workflow, 4, WorkflowNodeType.Integration, "google.calendar.create-events",
                "Create calendar events",
                """{"syncCalendar":"$.inputs.syncCalendar?","reportJson":"$.steps[1].approvedOutput","calendarId":"$.inputs.calendarId?","asOfDate":"$.inputs.asOfDate","workingHoursStart":"$.inputs.workingHoursStart","workingHoursEnd":"$.inputs.workingHoursEnd"}""",
                """{"when":{"input":"syncCalendar","equalsAny":["true"]}}"""),
            Step(Id(15), workflow, 5, WorkflowNodeType.Integration, "google.gmail.send-html",
                "Email action plan",
                """{"sendEmail":"$.inputs.sendEmail?","recipient":"$.inputs.recipientEmail?","subject":"$.literal.Your action plan","reportJson":"$.steps[1].approvedOutput"}""",
                """{"when":{"input":"sendEmail","equalsAny":["true"]}}"""),
            Step(Id(16), workflow, 6, WorkflowNodeType.Agent, resultAgent.Key,
                resultAgent.Name, """{"report":"$.steps[1].approvedOutput"}""",
                contractKey: "arzly.report", contractVersion: 4)
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
            RequiresHumanApproval = type == WorkflowNodeType.HumanApproval,
            ConfigurationJson = configuration,
            ResultContractKey = contractKey,
            ResultContractVersion = contractVersion
        };

    private static readonly string[] RequiredIntegrationKeys =
    [
        "google.tasks.create",
        "google.calendar.create-events",
        "google.gmail.send-html"
    ];

    private static async Task<IReadOnlyDictionary<string, IntegrationDefinition>>
        EnsureIntegrationsAsync(ArzlyDbContext dbContext, CancellationToken cancellationToken)
    {
        var definitions = new[]
        {
            Integration("1904", "google.tasks.create", "Google Tasks Create",
                "Create tasks and subtasks from an approved action plan."),
            Integration("1905", "google.calendar.create-events", "Google Calendar Events",
                "Create time-blocked calendar events from an approved action plan."),
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

    private const string ReviewApproval =
        """{"acceptLabel":"Approve and sync","editLabel":"Revise plan","rejectLabel":"Discard"}""";

    private const string PlannerInstructions =
        "Turn the brain dump into an arzly.report version 4 actionPlan document. Organize items into " +
        "quick wins, projects with subtasks, a realistic schedule within working hours, and priority " +
        "classifications (Do Now, Schedule, Delegate, Defer). Use quickWins, projects, schedule, " +
        "priorityCallout, and nextSteps blocks. Each block data object must contain text, items, and " +
        "metrics. Items use label, value, and detail. Put subtasks on separate lines in detail for " +
        "projects. Schedule items should include realistic time ranges in value. Never invent tasks the " +
        "user did not mention. Never output credentials, markdown, HTML, or the raw brain dump. " +
        "Sources must be empty. Return only JSON.";

    private const string InputSchema = """
{"version":1,"fields":[{"key":"brainDump","label":"Brain dump","type":"multilineText","required":true,"maxLength":8000},{"key":"asOfDate","label":"Plan date","type":"text","required":true},{"key":"workingHoursStart","label":"Work day starts","type":"text","required":true},{"key":"workingHoursEnd","label":"Work day ends","type":"text","required":true},{"key":"energyPreference","label":"Energy preference","type":"text","required":false},{"key":"syncTasks","label":"Sync tasks","type":"text","required":false},{"key":"syncCalendar","label":"Sync calendar","type":"text","required":false},{"key":"sendEmail","label":"Send email","type":"text","required":false},{"key":"recipientEmail","label":"Recipient email","type":"text","required":false},{"key":"taskListTitle","label":"Task list","type":"text","required":false},{"key":"calendarId","label":"Calendar id","type":"text","required":false}]}
""";

    private const string ReportSchema = """
{"type":"object","additionalProperties":false,"properties":{"schema":{"type":"string","const":"arzly.report"},"version":{"type":"integer","const":4},"kind":{"type":"string","const":"actionPlan"},"title":{"type":"string"},"summary":{"type":"string"},"generatedAtUtc":{"type":"string"},"blocks":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"type":{"type":"string","enum":["quickWins","projects","schedule","priorityCallout","nextSteps"]},"title":{"type":"string"},"data":{"type":"object","additionalProperties":false,"properties":{"text":{"type":"string"},"items":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"label":{"type":"string"},"value":{"type":"string"},"detail":{"type":"string"}},"required":["label","value","detail"]}},"metrics":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"label":{"type":"string"},"value":{"type":"number"},"maximum":{"type":"number"}},"required":["label","value","maximum"]}}},"required":["text","items","metrics"]}},"required":["type","title","data"]}},"sources":{"type":"array","maxItems":0}},"required":["schema","version","kind","title","summary","generatedAtUtc","blocks","sources"]}
""";
}
