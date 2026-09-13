using ArzlyAI.Application.DTOs.Presets;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Application.Services.Models;

namespace ArzlyAI.Application.Mappers.Presets;

public sealed class PresetMapper(IModelCapabilityPolicy capabilities) : IPresetMapper
{
    public PresetSummaryResponse ToSummaryResponse(PresetDefinition preset) =>
        new(preset.Id, preset.Key, preset.Name, preset.Description, preset.Version,
            preset.Subtitle, ToBackgroundResponse(preset));

    public PresetDetailsResponse ToDetailsResponse(PresetDefinition preset) => new(
        preset.Id,
        preset.Key,
        preset.Name,
        preset.Description,
        preset.Version,
        preset.Agents.OrderBy(agent => agent.Key).Select(ToAgentResponse).ToList(),
        new WorkflowGraphResponse(
            preset.Workflow.Key,
            preset.Workflow.Steps.OrderBy(step => step.Position).Select(step => new WorkflowNodeResponse(
                step.Id,
                string.IsNullOrWhiteSpace(step.Key) ? step.ReferenceKey : step.Key,
                step.DisplayName,
                step.Type.ToString(),
                step.Position,
                step.RequiresHumanApproval,
                step.ConfigurationJson,
                step.ResultContractKey is not null && step.ResultContractVersion is not null
                    ? new ResultContractResponse(step.ResultContractKey, step.ResultContractVersion.Value)
                    : null)).ToList(),
            preset.Workflow.Connections.Select(connection => new WorkflowConnectionResponse(
                connection.Id,
                connection.SourceStepId,
                connection.TargetStepId)).ToList()),
        preset.Integrations.Select(integration => new IntegrationRequirementResponse(
            integration.Integration.Key,
            integration.Integration.DisplayName,
            integration.Integration.Description,
            integration.Integration.CredentialSchemaJson,
            integration.Integration.Connector?.Key,
            integration.Integration.RequiredOAuthScopesJson,
            integration.Integration.RequiredApisJson,
            integration.Integration.SupportsBackgroundExecution)).ToList(),
        preset.InputSchemaJson,
        preset.ResultContractKey is not null && preset.ResultContractVersion is not null
            ? new ResultContractResponse(preset.ResultContractKey, preset.ResultContractVersion.Value)
            : null,
        preset.Subtitle,
        preset.DetailedDescription,
        ToBackgroundResponse(preset));

    private static BackgroundExecutionPolicyResponse ToBackgroundResponse(PresetDefinition preset) =>
        new(preset.BackgroundExecutionMode.ToString(), preset.BackgroundExecutionRationale,
            preset.AllowedTriggerTypesJson);

    private AgentResponse ToAgentResponse(AgentDefinition agent) => new(
        agent.Key,
        agent.Name,
        agent.Instructions,
        IsSystemPromptEditable: false,
        new AgentModelConfigurationResponse(
            agent.Model.Provider.Key,
            agent.Model.Key,
            agent.Model.Provider.Models.Select(model => new ModelOptionResponse(
                agent.Model.Provider.Key,
                model.Key,
                model.DisplayName)).ToList(),
            agent.AllowModelOverride,
            agent.DefaultTemperature,
            agent.MinimumTemperature,
            agent.MaximumTemperature,
            agent.AllowTemperatureOverride,
            capabilities.SupportsWebSearch(agent.Model.Provider.Key, agent.Model.Key)),
        new AgentHarnessResponse(
            agent.Harness.PlanningEnabled,
            agent.Harness.TodoTrackingEnabled,
            agent.Harness.ContextCompactionEnabled,
            agent.Harness.RequireToolApproval,
            agent.Harness.MaxIterations,
            agent.Harness.WebSearchEnabled));
}
