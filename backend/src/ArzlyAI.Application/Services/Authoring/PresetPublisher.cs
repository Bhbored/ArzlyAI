using System.Text.Json;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Authoring;

public sealed class PresetPublisher(
    IPresetAuthoringRepository sessions,
    ICapabilityCatalogRepository catalog,
    IPresetPublishingRepository publishing,
    IPresetDraftValidator validator) : IPresetPublisher
{
    public async Task<Guid> PublishAsync(
        Guid sessionId,
        Guid adminId,
        int expectedRevision,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetPublisher.Publish");
        var session = await sessions.GetAsync(sessionId, cancellationToken)
            ?? throw new KeyNotFoundException($"Authoring session '{sessionId}' was not found.");
        if (session.Status is AuthoringSessionStatus.Published or AuthoringSessionStatus.Abandoned)
            throw new InvalidOperationException("The authoring session cannot be published.");
        if (session.Revision != expectedRevision)
            throw new InvalidOperationException("The draft revision is stale. Reload before publishing.");
        var draft = session.DraftJson is null
            ? throw new InvalidOperationException("The authoring session has no draft.")
            : PresetDraftSerializer.Deserialize(session.DraftJson);
        var validation = await validator.ValidateAsync(draft, cancellationToken);
        session.ValidationJson = PresetDraftSerializer.Serialize(validation);
        if (!validation.IsValid)
        {
            await sessions.SaveAsync(cancellationToken);
            throw new PresetValidationException(validation);
        }

        var models = await catalog.ListModelsAsync(cancellationToken);
        var integrations = await catalog.ListIntegrationsAsync(cancellationToken);
        var version = await publishing.GetNextVersionAsync(draft.Key, cancellationToken);
        var supersedesId = await publishing.GetActivePresetIdAsync(draft.Key, cancellationToken);
        var preset = Compile(draft, version, supersedesId, adminId, models, integrations);
        await publishing.PublishAsync(session, preset, cancellationToken);
        return preset.Id;
    }

    private static PresetDefinition Compile(
        PresetDraftDocument draft,
        int version,
        Guid? supersedesId,
        Guid adminId,
        IReadOnlyList<ModelDefinition> models,
        IReadOnlyList<IntegrationDefinition> integrations)
    {
        var preset = new PresetDefinition
        {
            Id = Guid.NewGuid(), Key = draft.Key, Name = draft.Title, Subtitle = draft.Subtitle,
            Description = draft.Description, DetailedDescription = draft.DetailedDescription,
            Version = version, Status = PresetPublicationStatus.Published,
            PublishedAtUtc = DateTimeOffset.UtcNow, PublishedByAdminId = adminId,
            SupersedesPresetId = supersedesId, InputSchemaJson = draft.InputSchemaJson,
            ResultContractKey = draft.ResultContractKey, ResultContractVersion = draft.ResultContractVersion,
            BackgroundExecutionMode = draft.BackgroundExecution.Mode,
            BackgroundExecutionRationale = draft.BackgroundExecution.Rationale,
            AllowedTriggerTypesJson = JsonSerializer.Serialize(draft.BackgroundExecution.AllowedTriggerTypes)
        };

        foreach (var source in draft.Agents)
        {
            var model = models.Single(x => string.Equals(x.Provider.Key, source.ProviderKey,
                    StringComparison.OrdinalIgnoreCase) &&
                string.Equals(x.Key, source.ModelKey, StringComparison.OrdinalIgnoreCase));
            var agent = new AgentDefinition
            {
                Id = Guid.NewGuid(), PresetId = preset.Id, Preset = preset, ModelId = model.Id, Model = model,
                Key = source.Key, Name = source.Name, Instructions = source.Instructions,
                RuntimeType = source.RuntimeType, DefaultTemperature = source.DefaultTemperature,
                MinimumTemperature = source.MinimumTemperature, MaximumTemperature = source.MaximumTemperature,
                AllowModelOverride = source.AllowModelOverride,
                AllowTemperatureOverride = source.AllowTemperatureOverride,
                OutputSchemaJson = source.OutputSchemaJson
            };
            agent.Harness = new AgentHarnessDefinition
            {
                Id = Guid.NewGuid(), AgentId = agent.Id, Agent = agent,
                PlanningEnabled = source.Harness.PlanningEnabled,
                TodoTrackingEnabled = source.Harness.TodoTrackingEnabled,
                ContextCompactionEnabled = source.Harness.ContextCompactionEnabled,
                RequireToolApproval = source.Harness.RequireToolApproval,
                MaxIterations = source.Harness.MaxIterations,
                WebSearchEnabled = source.Harness.WebSearchEnabled
            };
            preset.Agents.Add(agent);
        }

        var workflow = new WorkflowDefinition
        {
            Id = Guid.NewGuid(), PresetId = preset.Id, Preset = preset, Key = draft.Workflow.Key
        };
        preset.Workflow = workflow;
        var stepByKey = new Dictionary<string, WorkflowStepDefinition>(StringComparer.Ordinal);
        foreach (var source in draft.Workflow.Nodes)
        {
            var step = new WorkflowStepDefinition
            {
                Id = Guid.NewGuid(), WorkflowId = workflow.Id, Workflow = workflow, Key = source.Key,
                Position = source.Position, Type = source.Type, ReferenceKey = source.ReferenceKey,
                DisplayName = source.DisplayName, InputMappingJson = source.InputMappingJson,
                RequiresHumanApproval = source.RequiresHumanApproval,
                ConfigurationJson = source.ConfigurationJson, ResultContractKey = source.ResultContractKey,
                ResultContractVersion = source.ResultContractVersion
            };
            workflow.Steps.Add(step);
            stepByKey.Add(source.Key, step);
        }
        foreach (var source in draft.Workflow.Connections)
            workflow.Connections.Add(new WorkflowConnectionDefinition
            {
                Id = Guid.NewGuid(), WorkflowId = workflow.Id, Workflow = workflow,
                SourceStepId = stepByKey[source.SourceNodeKey].Id,
                TargetStepId = stepByKey[source.TargetNodeKey].Id
            });

        var integrationKeys = draft.Workflow.Nodes.Where(x => x.Type == WorkflowNodeType.Integration)
            .Select(x => x.ReferenceKey).Distinct(StringComparer.Ordinal);
        foreach (var key in integrationKeys)
        {
            var integration = integrations.Single(x => x.Key == key);
            preset.Integrations.Add(new PresetIntegration
            {
                PresetId = preset.Id, Preset = preset,
                IntegrationId = integration.Id, Integration = integration
            });
        }
        for (var index = 0; index < draft.AdminNotes.Count; index++)
        {
            var note = draft.AdminNotes[index];
            preset.AdminNotes.Add(new PresetAdminNote
            {
                Id = Guid.NewGuid(), PresetId = preset.Id, Preset = preset,
                Title = note.Title, Description = note.Description, Severity = note.Severity,
                LinksJson = JsonSerializer.Serialize(note.Links), DisplayOrder = index
            });
        }
        return preset;
    }
}
