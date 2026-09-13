using System.Text.Json;
using System.Text.RegularExpressions;
using ArzlyAI.Application.Models;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed partial class WorkflowInputMapper : IWorkflowInputMapper
{
    public IReadOnlyDictionary<string, string> Map(
        WorkflowStepDefinition step,
        IReadOnlyList<WorkflowStepDefinition> plan,
        WorkflowRun run)
    {
        using var operation = Operation.Time("WorkflowInputMapper.Map");
        Dictionary<string, string>? mappings;
        try
        {
            mappings = JsonSerializer.Deserialize<Dictionary<string, string>>(step.InputMappingJson);
        }
        catch (JsonException exception)
        {
            throw new ArgumentException(
                $"Node '{step.ReferenceKey}' has invalid input mapping JSON.", exception);
        }

        var resolved = mappings?.ToDictionary(
            mapping => mapping.Key,
            mapping => Resolve(mapping.Value, plan, run),
            StringComparer.Ordinal) ?? new Dictionary<string, string>(StringComparer.Ordinal);
        if (run.RegenerationFeedback.TryGetValue(step.Id, out var feedback))
            resolved["editFeedback"] = feedback;
        return resolved;
    }

    private static string Resolve(
        string path,
        IReadOnlyList<WorkflowStepDefinition> plan,
        WorkflowRun run)
    {
        const string literalPrefix = "$.literal.";
        if (path.StartsWith(literalPrefix, StringComparison.Ordinal))
            return path[literalPrefix.Length..];

        const string inputPrefix = "$.inputs.";
        if (path.StartsWith(inputPrefix, StringComparison.Ordinal))
        {
            var key = path[inputPrefix.Length..];
            if (key.EndsWith("?", StringComparison.Ordinal))
            {
                key = key[..^1];
                return run.Inputs.GetValueOrDefault(key) ?? string.Empty;
            }
            return Required(run.Inputs, key, path);
        }

        var nodeMatch = NodePath().Match(path);
        if (nodeMatch.Success)
        {
            var nodeKey = nodeMatch.Groups[1].Value;
            var sourceStep = plan.SingleOrDefault(candidate =>
                string.Equals(candidate.Key, nodeKey, StringComparison.Ordinal));
            if (sourceStep is null)
                throw new ArgumentException($"Input mapping path '{path}' references a missing node.");
            return ResolveNodeMember(path, nodeMatch.Groups[2].Value,
                run.Nodes.Single(node => node.NodeId == sourceStep.Id), run);
        }

        var match = StepPath().Match(path);
        if (!match.Success)
            throw new ArgumentException($"Input mapping path '{path}' is not supported.");

        var index = int.Parse(match.Groups[1].Value);
        if (index < 0 || index >= plan.Count)
            throw new ArgumentException($"Input mapping path '{path}' references a missing step.");

        var source = run.Nodes.Single(node => node.NodeId == plan[index].Id);
        return ResolveNodeMember(path, match.Groups[2].Value, source, run);
    }

    private static string ResolveNodeMember(
        string path,
        string member,
        WorkflowNodeRun source,
        WorkflowRun run)
    {
        if (member == "approvedOutput")
        {
            if (source.Type != WorkflowNodeType.HumanApproval)
                throw new ArgumentException($"Input mapping path '{path}' does not reference an approval node.");
            return run.ApprovedOutputs.TryGetValue(source.NodeId, out var approvedOutput) &&
                   !string.IsNullOrWhiteSpace(approvedOutput)
                ? approvedOutput
                : throw new ArgumentException($"Input mapping path '{path}' has no approved value.");
        }

        return !string.IsNullOrWhiteSpace(source.Output)
            ? source.Output
            : throw new ArgumentException($"Input mapping path '{path}' has no available value.");
    }

    private static string Required(
        IReadOnlyDictionary<string, string> values,
        string key,
        string path) =>
        values.TryGetValue(key, out var value) && !string.IsNullOrWhiteSpace(value)
            ? value
            : throw new ArgumentException($"Input mapping path '{path}' has no available value.");

    [GeneratedRegex(@"^\$\.steps\[(\d+)\]\.(output|approvedOutput)$", RegexOptions.CultureInvariant)]
    private static partial Regex StepPath();

    [GeneratedRegex(@"^\$\.nodes\.([a-z0-9.-]+)\.(output|approvedOutput)$", RegexOptions.CultureInvariant)]
    private static partial Regex NodePath();
}
