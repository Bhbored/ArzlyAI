using ArzlyAI.Application.Mappers.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Services.Workflows.Rendering;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Tests;

public sealed class WorkflowRunMapperTests
{
    [Fact]
    public void ToResponse_WhenFinalReportAwaitsApproval_IncludesHtmlAndEffectiveModel()
    {
        var node = new WorkflowNodeRun
        {
            NodeId = Guid.NewGuid(),
            NodeKey = "report-composer",
            DisplayName = "Compose report",
            Type = WorkflowNodeType.Agent,
            Status = WorkflowNodeStatus.Completed,
            EffectiveProvider = "openai",
            EffectiveModel = "gpt-4o-mini",
            EffectiveTemperature = 0.2
        };
        var report = """
        {"schema":"arzly.report","version":2,"kind":"purchaseDecision","title":"Decision","summary":"Summary","blocks":[],"sources":[]}
        """;
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "smart-purchase-decision",
            Status = WorkflowRunStatus.WaitingForApproval,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 2,
            OriginalContent = report,
            CurrentContent = report,
            Nodes = [node]
        };
        var mapper = new WorkflowRunMapper([new ArzlyReportHtmlRenderer()]);

        var response = mapper.ToResponse(run);

        Assert.Equal("text/html", response.RenderedResult?.MediaType);
        Assert.Contains("<!doctype html>", response.RenderedResult?.Content, StringComparison.OrdinalIgnoreCase);
        Assert.Equal("gpt-4o-mini", response.Nodes[0].EffectiveModel);
        Assert.Equal(0.2, response.Nodes[0].EffectiveTemperature);
    }
}
