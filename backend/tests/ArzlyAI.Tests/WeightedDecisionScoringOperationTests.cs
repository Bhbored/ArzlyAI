using System.Text.Json;
using ArzlyAI.Application.Services.Workflows.Operations;

namespace ArzlyAI.Tests;

public sealed class WeightedDecisionScoringOperationTests
{
    [Fact]
    public async Task ExecuteAsync_WhenEvidenceValid_RanksByWeightedFit()
    {
        const string evidence = """
        {"criteria":[{"key":"battery","weight":60},{"key":"price","weight":40}],"candidates":[{"id":"a","name":"A","totalOwnershipCost":1000,"evidenceConfidence":0.9,"criterionScores":[{"key":"battery","score":90,"mandatory":false,"passes":true},{"key":"price","score":60,"mandatory":false,"passes":true}]},{"id":"b","name":"B","totalOwnershipCost":800,"evidenceConfidence":0.8,"criterionScores":[{"key":"battery","score":70,"mandatory":false,"passes":true},{"key":"price","score":90,"mandatory":false,"passes":true}]}],"sources":[],"conflicts":[]}
        """;

        var result = await new WeightedDecisionScoringOperation().ExecuteAsync(
            new Dictionary<string, string> { ["evidence"] = evidence }, CancellationToken.None);

        using var document = JsonDocument.Parse(result);
        var candidates = document.RootElement.GetProperty("candidates");
        Assert.Equal("b", candidates[0].GetProperty("id").GetString());
        Assert.Equal(78, candidates[0].GetProperty("fitScore").GetDouble());
        Assert.Equal(1, candidates[0].GetProperty("rank").GetInt32());
    }

    [Fact]
    public async Task ExecuteAsync_WhenMandatoryConstraintFails_DisqualifiesCandidate()
    {
        const string evidence = """
        {"criteria":[{"key":"budget","weight":100}],"candidates":[{"id":"a","name":"A","totalOwnershipCost":100,"evidenceConfidence":1,"criterionScores":[{"key":"budget","score":100,"mandatory":true,"passes":false}]},{"id":"b","name":"B","totalOwnershipCost":200,"evidenceConfidence":1,"criterionScores":[{"key":"budget","score":50,"mandatory":true,"passes":true}]}]}
        """;

        var result = await new WeightedDecisionScoringOperation().ExecuteAsync(
            new Dictionary<string, string> { ["evidence"] = evidence }, CancellationToken.None);

        using var document = JsonDocument.Parse(result);
        var candidates = document.RootElement.GetProperty("candidates");
        Assert.Equal("b", candidates[0].GetProperty("id").GetString());
        Assert.True(candidates[1].GetProperty("disqualified").GetBoolean());
    }
}
