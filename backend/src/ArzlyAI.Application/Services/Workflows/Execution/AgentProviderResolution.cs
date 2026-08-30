using ArzlyAI.Application.Constants;
using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Services.Workflows.Execution;

internal static class AgentProviderResolution
{
    public static string Resolve(
        AgentDefinition agent,
        AgentOverrideRequest? agentOverride,
        WorkflowRun run,
        Guid stepId,
        IModelCapabilityPolicy capabilities)
    {
        if (!string.IsNullOrWhiteSpace(agentOverride?.Provider))
        {
            if (!agent.AllowModelOverride)
                throw new ArgumentException($"Agent '{agent.Key}' does not allow provider changes.");
            if (!AiProviderKeys.IsSupported(agentOverride.Provider))
                throw new ArgumentException($"Provider '{agentOverride.Provider}' is not supported.");
            return agentOverride.Provider.ToLowerInvariant();
        }

        if (!string.IsNullOrWhiteSpace(agentOverride?.Model) && agent.AllowModelOverride)
        {
            var inferred = InferProviderFromModel(agentOverride.Model, capabilities);
            if (inferred is not null)
                return inferred;
        }

        foreach (var node in run.Nodes)
        {
            if (node.Type != WorkflowNodeType.Agent) continue;
            if (node.Status != WorkflowNodeStatus.Completed) continue;
            if (string.IsNullOrWhiteSpace(node.EffectiveProvider)) continue;
            return node.EffectiveProvider.ToLowerInvariant();
        }

        foreach (var otherOverride in run.AgentOverrides)
        {
            if (string.Equals(otherOverride.AgentKey, agent.Key, StringComparison.Ordinal))
                continue;
            if (!string.IsNullOrWhiteSpace(otherOverride.Provider))
                return otherOverride.Provider.ToLowerInvariant();
            if (!string.IsNullOrWhiteSpace(otherOverride.Model))
            {
                var inferred = InferProviderFromModel(otherOverride.Model, capabilities);
                if (inferred is not null)
                    return inferred;
            }
        }

        var currentNode = run.Nodes.SingleOrDefault(node => node.NodeId == stepId);
        if (!string.IsNullOrWhiteSpace(currentNode?.EffectiveProvider))
            return currentNode!.EffectiveProvider!.ToLowerInvariant();

        return agent.Model.Provider.Key;
    }

    public static string? InferProviderFromModel(string model, IModelCapabilityPolicy capabilities)
    {
        foreach (var candidate in AiProviderKeys.All)
        {
            if (capabilities.IsUsable(candidate, model))
                return candidate;
        }

        return null;
    }
}
