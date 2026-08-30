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

        var match = StepPath().Match(path);
        if (!match.Success)
            throw new ArgumentException($"Input mapping path '{path}' is not supported.");

        var index = int.Parse(match.Groups[1].Value);
        if (index < 0 || index >= plan.Count)
            throw new ArgumentException($"Input mapping path '{path}' references a missing step.");

        var source = run.Nodes.Single(node => node.NodeId == plan[index].Id);
        var member = match.Groups[2].Value;
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
}
