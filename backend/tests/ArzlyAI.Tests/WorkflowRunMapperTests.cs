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
            NodeKey = "shop-and-recommend",
            DisplayName = "Search and compare",
            Type = WorkflowNodeType.Agent,
            Status = WorkflowNodeStatus.Completed,
            EffectiveProvider = "openai",
            EffectiveModel = "gpt-4o-mini",
            EffectiveTemperature = 0.2
        };
        var report = """
        {"schema":"arzly.report","version":4,"kind":"purchaseDecision","title":"Decision","summary":"Summary","generatedAtUtc":"2026-08-30T12:00:00Z","blocks":[],"sources":[]}
        """;
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "smart-purchase-decision",
            Status = WorkflowRunStatus.WaitingForApproval,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4,
            OriginalContent = report,
            CurrentContent = report,
            Nodes = [node]
        };
        var mapper = new WorkflowRunMapper([new ArzlyReportHtmlRenderer()]);

        var response = mapper.ToResponse(run);

        Assert.Equal("text/html", response.RenderedResult?.MediaType);
        Assert.Contains("<!doctype html>", response.RenderedResult?.Content, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Smart Buy", response.RenderedResult?.Content, StringComparison.Ordinal);
        Assert.Equal("gpt-4o-mini", response.Nodes[0].EffectiveModel);
        Assert.Equal(0.2, response.Nodes[0].EffectiveTemperature);
    }

    [Fact]
    public void ToResponse_WhenApprovalContentIsNonReportJson_DoesNotThrow()
    {
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "smart-purchase-decision",
            Status = WorkflowRunStatus.WaitingForApproval,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4,
            OriginalContent = """
            {"summary":"Quiet vacuum","checklist":["Under $200"],"countryCode":"US","currencyCode":"USD"}
            """,
            CurrentContent = """
            {"summary":"Quiet vacuum","checklist":["Under $200"],"countryCode":"US","currencyCode":"USD"}
            """,
            Nodes = []
        };
        var mapper = new WorkflowRunMapper([new ArzlyReportHtmlRenderer()]);

        var response = mapper.ToResponse(run);

        Assert.Null(response.ResultDocument);
        Assert.Null(response.RenderedResult);
    }

    [Fact]
    public void ToResponse_WhenApprovalContentIsInvalidJson_DoesNotThrowBeforeFinalResponse()
    {
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "smart-purchase-decision",
            Status = WorkflowRunStatus.WaitingForApproval,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4,
            OriginalContent = "Thanks! Here is your request:",
            CurrentContent = "Thanks! Here is your request:",
            Nodes = []
        };
        var mapper = new WorkflowRunMapper([new ArzlyReportHtmlRenderer()]);

        var response = mapper.ToResponse(run);

        Assert.Null(response.ResultDocument);
        Assert.Null(response.RenderedResult);
    }

    [Fact]
    public void ToResponse_WhenReportMissingSchemaEnvelope_NormalizesAndRendersHtml()
    {
        var report = """
        {"kind":"purchaseDecision","title":"Top Laptop Picks","summary":"Here are options.","generatedAtUtc":"2026-08-30T12:00:00Z","blocks":[{"type":"recommendation","title":"Winner","data":{"text":"Best pick","items":[{"label":"HP Victus","value":"$899","detail":"Good GPU","imageUrl":null,"actions":[]}]}}],"sources":[]}
        """;
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "smart-purchase-decision",
            Status = WorkflowRunStatus.WaitingForApproval,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4,
            OriginalContent = report,
            CurrentContent = report,
            Nodes = []
        };
        var mapper = new WorkflowRunMapper([new ArzlyReportHtmlRenderer()]);

        var response = mapper.ToResponse(run);

        Assert.Equal("arzly.report", response.ResultDocument?.GetProperty("schema").GetString());
        Assert.Equal(4, response.ResultDocument?.GetProperty("version").GetInt32());
        Assert.Equal("text/html", response.RenderedResult?.MediaType);
        Assert.Contains("Top Laptop Picks", response.RenderedResult?.Content, StringComparison.Ordinal);
    }

    [Fact]
    public void ToResponse_WhenReportHasVersionAndBlocksWithoutKind_NormalizesAndRendersHtml()
    {
        var report = """
        {"version":4,"title":"Laptops in Lebanon","summary":"Options under $800","generatedAtUtc":"2026-08-30T17:40:13Z","blocks":[{"data":{"text":"Pick one","items":[{"label":"Acer Aspire 5","value":"$799","detail":"Dedicated GPU","actions":[]}]}}],"sources":[]}
        """;
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "smart-purchase-decision",
            Status = WorkflowRunStatus.WaitingForApproval,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4,
            OriginalContent = report,
            CurrentContent = report,
            Nodes = []
        };
        var mapper = new WorkflowRunMapper([new ArzlyReportHtmlRenderer()]);

        var response = mapper.ToResponse(run);

        Assert.Equal("arzly.report", response.ResultDocument?.GetProperty("schema").GetString());
        Assert.Equal("purchaseDecision", response.ResultDocument?.GetProperty("kind").GetString());
        Assert.Equal("text/html", response.RenderedResult?.MediaType);
        Assert.Contains("Acer Aspire 5", response.RenderedResult?.Content, StringComparison.Ordinal);
    }

    [Fact]
    public void ToResponse_WhenReportHasVersionAndSourcesWithoutBlocks_NormalizesAndRendersHtml()
    {
        var report = """
        {"version":4,"title":"Laptops in Lebanon","summary":"Options under $800","generatedAtUtc":"2026-08-30T17:40:13Z","sources":[{"id":"s1","title":"Acer Aspire 5 A515-46-R74Z","url":"https://lebtechlb.com/acer","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"},{"id":"s2","title":"Lenovo IdeaPad 3 14ITL6","url":"https://lebtechlb.com/lenovo","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"}]}
        """;
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "smart-purchase-decision",
            Status = WorkflowRunStatus.WaitingForApproval,
            ResultContractKey = "arzly.report",
            ResultContractVersion = 4,
            OriginalContent = report,
            CurrentContent = report,
            Nodes = []
        };
        var mapper = new WorkflowRunMapper([new ArzlyReportHtmlRenderer()]);

        var response = mapper.ToResponse(run);

        Assert.Equal("arzly.report", response.ResultDocument?.GetProperty("schema").GetString());
        Assert.Equal("purchaseDecision", response.ResultDocument?.GetProperty("kind").GetString());
        Assert.Equal("text/html", response.RenderedResult?.MediaType);
        Assert.Contains("Acer Aspire 5", response.RenderedResult?.Content, StringComparison.Ordinal);
        Assert.Contains("Lenovo IdeaPad", response.RenderedResult?.Content, StringComparison.Ordinal);
    }
}
