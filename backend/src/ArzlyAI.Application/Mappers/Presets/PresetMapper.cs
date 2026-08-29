using ArzlyAI.Application.DTOs.Presets;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Mappers.Presets;

public sealed class PresetMapper : IPresetMapper
{
    public PresetSummaryResponse ToSummaryResponse(PresetDefinition preset) =>
        new(preset.Id, preset.Key, preset.Name, preset.Description, preset.Version);

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
                step.ReferenceKey,
                step.DisplayName,
                step.Type.ToString(),
                step.Position,
                step.RequiresHumanApproval)).ToList(),
            preset.Workflow.Connections.Select(connection => new WorkflowConnectionResponse(
                connection.Id,
                connection.SourceStepId,
                connection.TargetStepId)).ToList()),
        preset.Integrations.Select(integration => new IntegrationRequirementResponse(
            integration.Integration.Key,
            integration.Integration.DisplayName,
            integration.Integration.Description,
            integration.Integration.CredentialSchemaJson)).ToList());

    private static AgentResponse ToAgentResponse(AgentDefinition agent) => new(
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
            agent.AllowTemperatureOverride),
        new AgentHarnessResponse(
            agent.Harness.PlanningEnabled,
            agent.Harness.TodoTrackingEnabled,
            agent.Harness.ContextCompactionEnabled,
            agent.Harness.RequireToolApproval,
            agent.Harness.MaxIterations));
}
