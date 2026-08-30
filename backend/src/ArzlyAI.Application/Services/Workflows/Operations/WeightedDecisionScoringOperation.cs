using System.Text.Json;
using System.Text.Json.Nodes;

namespace ArzlyAI.Application.Services.Workflows.Operations;

public sealed class WeightedDecisionScoringOperation : IWorkflowOperation
{
    public const string OperationKey = "decision.weighted-score";
    public string Key => OperationKey;

    public Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        if (!inputs.TryGetValue("evidence", out var evidence) || string.IsNullOrWhiteSpace(evidence))
            throw new ArgumentException("Weighted scoring requires evidence input.");

        var root = JsonNode.Parse(evidence)?.AsObject()
            ?? throw new ArgumentException("Evidence must be a JSON object.");
        var criteria = root["criteria"]?.AsArray()
            ?? throw new ArgumentException("Evidence must contain criteria.");
        var candidates = root["candidates"]?.AsArray()
            ?? throw new ArgumentException("Evidence must contain candidates.");
        if (candidates.Count is < 2 or > 5)
            throw new ArgumentException("Evidence must contain between two and five candidates.");

        var weights = criteria.ToDictionary(
            item => RequiredString(item, "key"),
            item => RequiredNumber(item, "weight"),
            StringComparer.Ordinal);
        if (weights.Count == 0 || weights.Values.Any(value => value < 0) || weights.Values.Sum() <= 0)
            throw new ArgumentException("Criterion weights must be non-negative and have a positive sum.");

        foreach (var candidateNode in candidates)
        {
            var candidate = candidateNode?.AsObject()
                ?? throw new ArgumentException("Candidate must be an object.");
            var scores = candidate["criterionScores"]?.AsArray()
                ?? throw new ArgumentException("Candidate must contain criterionScores.");
            var disqualified = scores.Any(score =>
                score?["mandatory"]?.GetValue<bool>() == true &&
                score?["passes"]?.GetValue<bool>() == false);
            var weightedTotal = 0d;
            foreach (var scoreNode in scores)
            {
                var key = RequiredString(scoreNode, "key");
                if (!weights.TryGetValue(key, out var weight))
                    throw new ArgumentException($"Unknown criterion score '{key}'.");
                var score = RequiredNumber(scoreNode, "score");
                if (score is < 0 or > 100)
                    throw new ArgumentException($"Criterion score '{key}' must be between 0 and 100.");
                weightedTotal += score * weight;
            }
            candidate["disqualified"] = disqualified;
            candidate["fitScore"] = disqualified
                ? 0
                : Math.Round(weightedTotal / weights.Values.Sum(), 2, MidpointRounding.AwayFromZero);
        }

        var ordered = candidates.Select(node => node!.AsObject())
            .OrderBy(candidate => candidate["disqualified"]?.GetValue<bool>() ?? false)
            .ThenByDescending(candidate => candidate["fitScore"]?.GetValue<double>() ?? 0)
            .ThenBy(candidate => candidate["totalOwnershipCost"]?.GetValue<double>() ?? double.MaxValue)
            .ThenByDescending(candidate => candidate["evidenceConfidence"]?.GetValue<double>() ?? 0)
            .ToList();
        for (var index = 0; index < ordered.Count; index++) ordered[index]["rank"] = index + 1;
        root["candidates"] = new JsonArray(ordered.Select(item => item.DeepClone()).ToArray());
        root["scoringMethod"] = "weighted-average-v1";
        return Task.FromResult(root.ToJsonString(new JsonSerializerOptions { WriteIndented = false }));
    }

    private static string RequiredString(JsonNode? node, string property) =>
        node?[property]?.GetValue<string>() is { Length: > 0 } value
            ? value
            : throw new ArgumentException($"'{property}' is required.");

    private static double RequiredNumber(JsonNode? node, string property) =>
        node?[property]?.GetValue<double>()
        ?? throw new ArgumentException($"'{property}' is required.");
}
