using System.Text.Json;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Services.Agents;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed class AgentWorkflowNodeHandler(
    IAgentRuntimeResolver runtimeResolver,
    IModelCapabilityPolicy capabilities) : IWorkflowNodeHandler
{
    public WorkflowNodeType NodeType => WorkflowNodeType.Agent;
    public bool StartsRunning => true;

    public string RunningMessage(WorkflowStepDefinition step) => $"{step.DisplayName} is running.";

    public async Task<WorkflowNodeExecutionResult> ExecuteAsync(
        WorkflowNodeExecutionContext context,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AgentWorkflowNodeHandler.Execute");
        var agent = context.Preset.Agents.SingleOrDefault(candidate => candidate.Key == context.Step.ReferenceKey)
            ?? throw new InvalidOperationException(
                $"Agent '{context.Step.ReferenceKey}' is not defined by preset '{context.Preset.Key}'.");
        var input = ComposeInput(context.Inputs);

        if (agent.RuntimeType == AgentRuntimeType.Passthrough)
            return new WorkflowNodeExecutionResult(
                input, WorkflowNodeStatus.Completed, $"{context.Step.DisplayName} completed.");

        var provider = AgentProviderResolution.Resolve(
            agent,
            context.AgentOverride,
            context.Run,
            context.Step.Id,
            capabilities);
        var effectiveModel = ResolveEffectiveModel(agent, context, provider);
        var model = ResolveModel(agent, provider, effectiveModel);
        if (agent.Harness.WebSearchEnabled &&
            !capabilities.SupportsWebSearch(provider, model))
            throw new ArgumentException($"Model '{model}' does not support hosted web search.");
        var temperature = ResolveTemperature(agent, provider, model, context.AgentOverride?.Temperature);
        var credentialKey = AiProviderKeys.CredentialKey(provider);
        var runtime = runtimeResolver.Resolve(provider);
        var output = await runtime.ExecuteAsync(
            agent,
            input,
            model,
            temperature,
            Required(context.Credentials, credentialKey),
            cancellationToken);

        return new WorkflowNodeExecutionResult(
            output,
            WorkflowNodeStatus.Completed,
            $"{context.Step.DisplayName} completed.",
            EffectiveProvider: provider,
            EffectiveModel: model,
            EffectiveTemperature: temperature);
    }

    private static string ComposeInput(IReadOnlyDictionary<string, string> inputs)
    {
        if (inputs.Count == 0)
            throw new ArgumentException("An agent node requires at least one mapped input.");
        if (inputs.Count == 1)
            return inputs.Single().Value;

        return JsonSerializer.Serialize(
            inputs.OrderBy(entry => entry.Key, StringComparer.Ordinal)
                .ToDictionary(entry => entry.Key, entry => entry.Value, StringComparer.Ordinal));
    }

    private string? ResolveEffectiveModel(
        AgentDefinition agent,
        WorkflowNodeExecutionContext context,
        string provider)
    {
        if (!string.IsNullOrWhiteSpace(context.AgentOverride?.Model))
            return context.AgentOverride.Model;

        foreach (var node in context.Run.Nodes)
        {
            if (node.Type != WorkflowNodeType.Agent) continue;
            if (node.Status != WorkflowNodeStatus.Completed) continue;
            if (string.IsNullOrWhiteSpace(node.EffectiveModel)) continue;
            var nodeProvider = node.EffectiveProvider ?? provider;
            if (agent.Harness.WebSearchEnabled &&
                !capabilities.SupportsWebSearch(nodeProvider, node.EffectiveModel))
            {
                continue;
            }
            return node.EffectiveModel;
        }

        foreach (var otherOverride in context.Run.AgentOverrides)
        {
            if (string.Equals(otherOverride.AgentKey, agent.Key, StringComparison.Ordinal))
                continue;
            if (string.IsNullOrWhiteSpace(otherOverride.Model)) continue;
            var otherProvider = otherOverride.Provider ?? provider;
            if (agent.Harness.WebSearchEnabled &&
                !capabilities.SupportsWebSearch(otherProvider, otherOverride.Model))
            {
                continue;
            }
            return otherOverride.Model;
        }

        var currentNode = context.Run.Nodes.SingleOrDefault(node => node.NodeId == context.Step.Id);
        return currentNode?.EffectiveModel;
    }

    private string ResolveModel(AgentDefinition agent, string provider, string? requested)
    {
        if (string.IsNullOrWhiteSpace(requested)) return agent.Model.Key;
        if (!agent.AllowModelOverride)
            throw new ArgumentException($"Agent '{agent.Key}' does not allow model changes.");
        if (!capabilities.IsUsable(provider, requested))
            throw new ArgumentException($"Model '{requested}' is not usable by this agent.");
        return requested;
    }

    private double? ResolveTemperature(
        AgentDefinition agent,
        string provider,
        string model,
        double? requested)
    {
        if (!agent.AllowTemperatureOverride)
        {
            if (requested is not null)
                throw new ArgumentException($"Agent '{agent.Key}' does not allow temperature changes.");
            return null;
        }

        if (!capabilities.SupportsTemperature(provider, model))
        {
            if (requested is not null)
                throw new ArgumentException($"Model '{model}' does not support temperature.");
            return null;
        }

        if (requested is null) return agent.DefaultTemperature;
        if (requested < agent.MinimumTemperature || requested > agent.MaximumTemperature)
            throw new ArgumentOutOfRangeException(nameof(requested));
        return requested.Value;
    }

    private static string Required(IReadOnlyDictionary<string, string> values, string key) =>
        values.TryGetValue(key, out var value) && !string.IsNullOrWhiteSpace(value)
            ? value
            : throw new ArgumentException($"Required credential '{key}' is missing.");
}
