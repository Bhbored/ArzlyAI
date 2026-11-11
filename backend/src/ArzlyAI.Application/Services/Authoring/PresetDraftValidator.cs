using System.Text.Json;
using System.Text.RegularExpressions;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Enums;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Authoring;

public sealed partial class PresetDraftValidator(
    ICapabilityCatalogRepository catalog,
    IModelCapabilityPolicy modelCapabilities) : IPresetDraftValidator
{
    private static readonly HashSet<string> TriggerTypes =
        new(["manual", "interval", "daily", "weekly"], StringComparer.Ordinal);

    public async Task<PresetValidationResult> ValidateAsync(
        PresetDraftDocument draft,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetDraftValidator.Validate");
        if (draft.Workflow?.Nodes is null || draft.Workflow.Connections is null || draft.Agents is null ||
            draft.BackgroundExecution?.AllowedTriggerTypes is null || draft.AdminNotes is null ||
            draft.Agents.Any(agent => agent is null || agent.Harness is null) ||
            draft.Workflow.Nodes.Any(node => node is null))
            throw new ArgumentException("The draft must include workflow nodes and connections, agents, background policy, and admin notes.");
        var errors = new List<PresetValidationIssue>();
        foreach (var duplicate in draft.Agents.GroupBy(agent => agent.Key).Where(group => group.Count() > 1))
            Add(errors, "agents", $"Agent key '{duplicate.Key}' is duplicated.");
        ValidateMetadata(draft, errors);
        ValidateJson(draft.InputSchemaJson, "inputSchemaJson", errors);
        ValidateInputSchema(draft.InputSchemaJson, errors);
        ValidateGraph(draft, errors);

        var integrations = (await catalog.ListIntegrationsAsync(cancellationToken))
            .Where(x => x.IsEnabled).ToDictionary(x => x.Key, StringComparer.Ordinal);
        var operations = (await catalog.ListOperationsAsync(cancellationToken))
            .Where(x => x.IsEnabled).ToDictionary(x => x.Key, StringComparer.Ordinal);
        var models = (await catalog.ListModelsAsync(cancellationToken))
            .ToDictionary(x => $"{x.Provider.Key}:{x.Key}", StringComparer.OrdinalIgnoreCase);

        foreach (var agent in draft.Agents)
        {
            if (string.IsNullOrWhiteSpace(agent.Name)) Add(errors, $"agents.{agent.Key}.name", "An agent name is required.");
            if (!Enum.IsDefined(agent.RuntimeType)) Add(errors, $"agents.{agent.Key}.runtimeType", "Choose a supported runtime.");
            if (!Slug().IsMatch(agent.Key)) Add(errors, $"agents.{agent.Key}.key", "Use a lowercase slug key.");
            if (!models.ContainsKey($"{agent.ProviderKey}:{agent.ModelKey}"))
                Add(errors, $"agents.{agent.Key}.model", "The provider/model is not in the catalog.");
            else if (!modelCapabilities.IsUsable(agent.ProviderKey, agent.ModelKey))
                Add(errors, $"agents.{agent.Key}.model", "The selected model is not usable by this runtime.");
            if (agent.MinimumTemperature > agent.DefaultTemperature ||
                agent.DefaultTemperature > agent.MaximumTemperature)
                Add(errors, $"agents.{agent.Key}.temperature", "Temperature bounds are inconsistent.");
            if (agent.Harness.MaxIterations is < 1 or > 20)
                Add(errors, $"agents.{agent.Key}.harness.maxIterations", "Max iterations must be between 1 and 20.");
            if (agent.Harness.WebSearchEnabled &&
                !modelCapabilities.SupportsWebSearch(agent.ProviderKey, agent.ModelKey))
                Add(errors, $"agents.{agent.Key}.harness.webSearchEnabled", "This model does not support web search.");
            if (agent.AllowTemperatureOverride &&
                !modelCapabilities.SupportsTemperature(agent.ProviderKey, agent.ModelKey))
                Add(errors, $"agents.{agent.Key}.allowTemperatureOverride", "This model does not support temperature.");
            if (agent.OutputSchemaJson is not null)
                ValidateJson(agent.OutputSchemaJson, $"agents.{agent.Key}.outputSchemaJson", errors);
        }

        var agentKeys = draft.Agents.Select(x => x.Key).ToHashSet(StringComparer.Ordinal);
        foreach (var node in draft.Workflow.Nodes)
        {
            if (!Enum.IsDefined(node.Type)) Add(errors, $"workflow.nodes.{node.Key}.type", "Choose a supported node type.");
            if (!Slug().IsMatch(node.Key)) Add(errors, $"workflow.nodes.{node.Key}.key", "Use a lowercase slug key.");
            if (node.Type == WorkflowNodeType.Agent && !agentKeys.Contains(node.ReferenceKey))
                Add(errors, $"workflow.nodes.{node.Key}.referenceKey", "The referenced agent does not exist.");
            if (node.Type == WorkflowNodeType.Integration && !integrations.ContainsKey(node.ReferenceKey))
                Add(errors, $"workflow.nodes.{node.Key}.referenceKey", "The integration is unavailable.");
            if (node.Type == WorkflowNodeType.Operation && !operations.ContainsKey(node.ReferenceKey))
                Add(errors, $"workflow.nodes.{node.Key}.referenceKey", "The operation is unavailable.");
            ValidateJson(node.InputMappingJson, $"workflow.nodes.{node.Key}.inputMappingJson", errors);
            if (node.Type == WorkflowNodeType.Integration && integrations.TryGetValue(node.ReferenceKey, out var integration))
                ValidateRequiredMappings(node, integration.InputSchemaJson, errors);
            if (node.Type == WorkflowNodeType.Operation && operations.TryGetValue(node.ReferenceKey, out var workflowOperation))
                ValidateRequiredMappings(node, workflowOperation.InputSchemaJson, errors);
            if (node.ConfigurationJson is not null)
                ValidateJson(node.ConfigurationJson, $"workflow.nodes.{node.Key}.configurationJson", errors);
            if (node.ResultContractKey is not null &&
                (node.ResultContractKey != "arzly.report" || node.ResultContractVersion != 4))
                Add(errors, $"workflow.nodes.{node.Key}.resultContract", "Only arzly.report version 4 is registered.");
        }

        if (draft.ResultContractKey is not null &&
            (draft.ResultContractKey != "arzly.report" || draft.ResultContractVersion != 4))
            Add(errors, "resultContract", "Only arzly.report version 4 is registered.");

        if (draft.BackgroundExecution.AllowedTriggerTypes.Any(x => !TriggerTypes.Contains(x)))
            Add(errors, "backgroundExecution.allowedTriggerTypes", "Allowed values are manual, interval, daily, and weekly.");
        if (draft.BackgroundExecution.Mode == BackgroundExecutionMode.NotApplicable &&
            draft.BackgroundExecution.AllowedTriggerTypes.Any(x => x != "manual"))
            Add(errors, "backgroundExecution", "A non-applicable background policy cannot expose scheduled triggers.");

        return new PresetValidationResult(errors);
    }

    private static void ValidateMetadata(PresetDraftDocument draft, ICollection<PresetValidationIssue> errors)
    {
        if (!Slug().IsMatch(draft.Key)) Add(errors, "key", "Use a lowercase slug key.");
        if (string.IsNullOrWhiteSpace(draft.Title)) Add(errors, "title", "A title is required.");
        if (string.IsNullOrWhiteSpace(draft.Subtitle)) Add(errors, "subtitle", "A subtitle is required.");
        if (string.IsNullOrWhiteSpace(draft.Description)) Add(errors, "description", "A description is required.");
        if (string.IsNullOrWhiteSpace(draft.DetailedDescription))
            Add(errors, "detailedDescription", "A detailed description is required.");
        if ((draft.ResultContractKey is null) != (draft.ResultContractVersion is null))
            Add(errors, "resultContract", "Result contract key and version must be supplied together.");
    }

    private static void ValidateGraph(PresetDraftDocument draft, ICollection<PresetValidationIssue> errors)
    {
        var nodes = draft.Workflow.Nodes;
        if (nodes.Count == 0)
        {
            Add(errors, "workflow.nodes", "At least one node is required.");
            return;
        }
        foreach (var duplicate in nodes.GroupBy(x => x.Key, StringComparer.Ordinal).Where(x => x.Count() > 1))
            Add(errors, "workflow.nodes", $"Node key '{duplicate.Key}' is duplicated.");
        foreach (var duplicate in nodes.GroupBy(x => x.Position).Where(x => x.Count() > 1))
            Add(errors, "workflow.nodes", $"Position '{duplicate.Key}' is duplicated.");

        var byKey = nodes.GroupBy(x => x.Key, StringComparer.Ordinal)
            .ToDictionary(x => x.Key, x => x.First(), StringComparer.Ordinal);
        var indegree = byKey.Keys.ToDictionary(x => x, _ => 0, StringComparer.Ordinal);
        var outgoing = byKey.Keys.ToDictionary(x => x, _ => new List<string>(), StringComparer.Ordinal);
        foreach (var edge in draft.Workflow.Connections)
        {
            if (!byKey.ContainsKey(edge.SourceNodeKey) || !byKey.ContainsKey(edge.TargetNodeKey))
            {
                Add(errors, "workflow.connections", "Every connection must reference existing nodes.");
                continue;
            }
            if (edge.SourceNodeKey == edge.TargetNodeKey)
            {
                Add(errors, "workflow.connections", "Self-referencing connections are not allowed.");
                continue;
            }
            outgoing[edge.SourceNodeKey].Add(edge.TargetNodeKey);
            indegree[edge.TargetNodeKey]++;
        }
        if (indegree.Count(x => x.Value == 0) != 1)
            Add(errors, "workflow", "The graph must have exactly one entry node.");
        if (outgoing.Count(x => x.Value.Count == 0) != 1)
            Add(errors, "workflow", "The graph must have exactly one terminal node.");

        var queue = new Queue<string>(indegree.Where(x => x.Value == 0).Select(x => x.Key));
        var visited = new HashSet<string>(StringComparer.Ordinal);
        while (queue.TryDequeue(out var current))
        {
            if (!visited.Add(current)) continue;
            foreach (var target in outgoing[current])
                if (--indegree[target] == 0) queue.Enqueue(target);
        }
        if (visited.Count != byKey.Count) Add(errors, "workflow", "The graph must be acyclic and fully connected.");

        foreach (var approval in nodes.Where(x => x.Type == WorkflowNodeType.HumanApproval))
        {
            var nearestAgents = FindNearestUpstreamAgents(approval.Key, nodes, draft.Workflow.Connections);
            if (nearestAgents.Count != 1)
                Add(errors, $"workflow.nodes.{approval.Key}",
                    "A human approval requires exactly one nearest upstream agent for edit regeneration.");
        }

        ValidateMappings(nodes, outgoing, byKey, errors);
    }

    private static void ValidateMappings(
        IReadOnlyList<PresetDraftNode> nodes,
        IReadOnlyDictionary<string, List<string>> outgoing,
        IReadOnlyDictionary<string, PresetDraftNode> byKey,
        ICollection<PresetValidationIssue> errors)
    {
        foreach (var node in nodes)
        {
            Dictionary<string, string>? mappings;
            try { mappings = JsonSerializer.Deserialize<Dictionary<string, string>>(node.InputMappingJson); }
            catch (JsonException) { continue; }
            foreach (var path in mappings?.Values ?? Enumerable.Empty<string>())
            {
                var match = NodePath().Match(path);
                if (!match.Success)
                {
                    if (!InputPath().IsMatch(path) && !path.StartsWith("$.literal.", StringComparison.Ordinal))
                        Add(errors, $"workflow.nodes.{node.Key}.inputMappingJson", $"Mapping path '{path}' is unsupported.");
                    continue;
                }
                var sourceKey = match.Groups[1].Value;
                if (!byKey.TryGetValue(sourceKey, out var source))
                {
                    Add(errors, $"workflow.nodes.{node.Key}.inputMappingJson", $"Node '{sourceKey}' does not exist.");
                    continue;
                }
                if (!CanReach(sourceKey, node.Key, outgoing))
                    Add(errors, $"workflow.nodes.{node.Key}.inputMappingJson", $"'{sourceKey}' is not upstream of this node.");
                if (match.Groups[2].Value == "approvedOutput" && source.Type != WorkflowNodeType.HumanApproval)
                    Add(errors, $"workflow.nodes.{node.Key}.inputMappingJson", "approvedOutput must reference a human approval node.");
            }
        }
    }

    private static IReadOnlySet<string> FindNearestUpstreamAgents(
        string approvalKey,
        IReadOnlyList<PresetDraftNode> nodes,
        IReadOnlyList<PresetDraftConnection> connections)
    {
        var byKey = nodes.GroupBy(x => x.Key, StringComparer.Ordinal)
            .ToDictionary(x => x.Key, x => x.First(), StringComparer.Ordinal);
        var incoming = connections.GroupBy(x => x.TargetNodeKey, StringComparer.Ordinal)
            .ToDictionary(x => x.Key, x => x.Select(edge => edge.SourceNodeKey).ToList(), StringComparer.Ordinal);
        var frontier = new Queue<string>([approvalKey]);
        var visited = new HashSet<string>(StringComparer.Ordinal);
        var agents = new HashSet<string>(StringComparer.Ordinal);
        while (frontier.Count > 0 && agents.Count == 0)
        {
            var count = frontier.Count;
            for (var index = 0; index < count; index++)
            {
                var current = frontier.Dequeue();
                if (!visited.Add(current) || !incoming.TryGetValue(current, out var sources)) continue;
                foreach (var source in sources)
                {
                    if (byKey.TryGetValue(source, out var node) && node.Type == WorkflowNodeType.Agent)
                        agents.Add(source);
                    else
                        frontier.Enqueue(source);
                }
            }
        }
        return agents;
    }

    private static bool CanReach(string source, string target, IReadOnlyDictionary<string, List<string>> outgoing)
    {
        var queue = new Queue<string>([source]);
        var visited = new HashSet<string>(StringComparer.Ordinal);
        while (queue.TryDequeue(out var current))
        {
            if (!visited.Add(current)) continue;
            foreach (var next in outgoing[current])
            {
                if (next == target) return true;
                queue.Enqueue(next);
            }
        }
        return false;
    }

    private static void ValidateJson(string json, string path, ICollection<PresetValidationIssue> errors)
    {
        if (string.IsNullOrWhiteSpace(json)) { Add(errors, path, "The value must be valid JSON."); return; }
        try { using var _ = JsonDocument.Parse(json); }
        catch (JsonException) { Add(errors, path, "The value must be valid JSON."); }
    }

    private static void ValidateInputSchema(string json, ICollection<PresetValidationIssue> errors)
    {
        if (string.IsNullOrWhiteSpace(json)) return;
        try
        {
            using var schema = JsonDocument.Parse(json);
            if (schema.RootElement.ValueKind != JsonValueKind.Object ||
                !schema.RootElement.TryGetProperty("type", out var type) ||
                type.ValueKind != JsonValueKind.String || type.GetString() != "object")
            {
                Add(errors, "inputSchemaJson", "The input schema must describe an object.");
                return;
            }
            if (!schema.RootElement.TryGetProperty("properties", out var properties))
            {
                if (schema.RootElement.TryGetProperty("required", out var requiredWithoutProperties) &&
                    requiredWithoutProperties.ValueKind == JsonValueKind.Array &&
                    requiredWithoutProperties.GetArrayLength() > 0)
                    Add(errors, "inputSchemaJson.required", "Required inputs need matching properties.");
                return;
            }
            if (properties.ValueKind != JsonValueKind.Object)
            {
                Add(errors, "inputSchemaJson.properties", "List the available input fields.");
                return;
            }
            foreach (var property in properties.EnumerateObject())
            {
                if (!Slug().IsMatch(property.Name))
                    Add(errors, $"inputSchemaJson.properties.{property.Name}", "Use a lowercase slug key.");
                if (property.Value.ValueKind != JsonValueKind.Object ||
                    !property.Value.TryGetProperty("type", out var fieldType) ||
                    fieldType.ValueKind != JsonValueKind.String ||
                    fieldType.GetString() is not ("string" or "number" or "integer" or "boolean" or "array" or "object"))
                    Add(errors, $"inputSchemaJson.properties.{property.Name}", "Choose a supported input type.");
            }
            if (schema.RootElement.TryGetProperty("required", out var required))
            {
                if (required.ValueKind != JsonValueKind.Array)
                    Add(errors, "inputSchemaJson.required", "Required inputs must be a list.");
                else foreach (var field in required.EnumerateArray())
                    if (field.ValueKind != JsonValueKind.String || !properties.TryGetProperty(field.GetString()!, out _))
                        Add(errors, "inputSchemaJson.required", "Every required input must exist in properties.");
            }
        }
        catch (JsonException) { /* Syntax is reported by ValidateJson. */ }
    }

    private static void ValidateRequiredMappings(
        PresetDraftNode node,
        string inputSchemaJson,
        ICollection<PresetValidationIssue> errors)
    {
        try
        {
            using var schema = JsonDocument.Parse(inputSchemaJson);
            using var mapping = JsonDocument.Parse(node.InputMappingJson);
            if (mapping.RootElement.ValueKind != JsonValueKind.Object)
            {
                Add(errors, $"workflow.nodes.{node.Key}.inputMappingJson", "The input mapping must be a JSON object.");
                return;
            }

            if (!schema.RootElement.TryGetProperty("required", out var required) ||
                required.ValueKind != JsonValueKind.Array)
                return;

            foreach (var property in required.EnumerateArray())
            {
                var name = property.GetString();
                if (name is not null && !mapping.RootElement.TryGetProperty(name, out _))
                    Add(errors, $"workflow.nodes.{node.Key}.inputMappingJson",
                        $"Required input mapping '{name}' is missing for '{node.ReferenceKey}'.");
            }
        }
        catch (JsonException)
        {
            // Invalid JSON is reported by ValidateJson; catalog schemas are verified when seeded.
        }
    }

    private static void Add(ICollection<PresetValidationIssue> errors, string path, string message) =>
        errors.Add(new PresetValidationIssue(path, message));

    [GeneratedRegex("^[a-z0-9]+(?:[.-][a-z0-9]+)*$", RegexOptions.CultureInvariant)]
    private static partial Regex Slug();

    [GeneratedRegex("^\\$\\.nodes\\.([a-z0-9.-]+)\\.(output|approvedOutput)$", RegexOptions.CultureInvariant)]
    private static partial Regex NodePath();

    [GeneratedRegex("^\\$\\.inputs\\.[a-zA-Z0-9_-]+\\??$", RegexOptions.CultureInvariant)]
    private static partial Regex InputPath();
}
