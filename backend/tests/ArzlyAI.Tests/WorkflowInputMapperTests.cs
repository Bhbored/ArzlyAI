using ArzlyAI.Application.Models;
using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Tests;

public sealed class WorkflowInputMapperTests
{
    [Fact]
    public void Map_WhenOptionalInputMissing_MapsEmptyValue()
    {
        var step = new WorkflowStepDefinition
        {
            Id = Guid.NewGuid(),
            WorkflowId = Guid.NewGuid(),
            Position = 0,
            Type = WorkflowNodeType.Agent,
            ReferenceKey = "agent",
            DisplayName = "Agent",
            InputMappingJson = "{\"optional\":\"$.inputs.optional?\"}"
        };
        var result = new WorkflowInputMapper().Map(step, [step], new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "test",
            Inputs = []
        });

        Assert.Equal(string.Empty, result["optional"]);
    }

    [Fact]
    public void Map_WhenLiteralPathProvided_MapsSeedConstant()
    {
        var step = new WorkflowStepDefinition
        {
            Id = Guid.NewGuid(),
            WorkflowId = Guid.NewGuid(),
            Position = 0,
            Type = WorkflowNodeType.Operation,
            ReferenceKey = "receipt.analyze",
            DisplayName = "Analyze",
            InputMappingJson = """{"mode":"$.literal.monthly-spending"}"""
        };

        var result = new WorkflowInputMapper().Map(step, [step], new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = "receipt"
        });

        Assert.Equal("monthly-spending", result["mode"]);
    }

    private readonly WorkflowInputMapper mapper = new();

    [Fact]
    public void Map_WhenPathsAreValid_ResolvesClientNodeAndApprovedInputs()
    {
        var generatedStep = Step(WorkflowNodeType.Agent, 0);
        var approvalStep = Step(WorkflowNodeType.HumanApproval, 1);
        var targetStep = Step(
            WorkflowNodeType.Integration,
            2,
            """{"topic":"$.inputs.topic","draft":"$.steps[0].output","content":"$.steps[1].approvedOutput"}""");
        var run = Run(generatedStep, approvalStep, targetStep);
        run.Inputs["topic"] = "AI trends";
        run.Nodes[0].Output = "Generated draft";
        run.ApprovedOutputs[approvalStep.Id] = "Edited draft";

        var result = mapper.Map(targetStep, [generatedStep, approvalStep, targetStep], run);

        Assert.Equal("AI trends", result["topic"]);
        Assert.Equal("Generated draft", result["draft"]);
        Assert.Equal("Edited draft", result["content"]);
    }

    [Fact]
    public void Map_WhenPathUsesUnsupportedSyntax_ThrowsArgumentException()
    {
        var step = Step(WorkflowNodeType.Agent, 0, """{"value":"$.unknown.value"}""");
        var run = Run(step);

        var exception = Assert.Throws<ArgumentException>(() => mapper.Map(step, [step], run));

        Assert.Contains("not supported", exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Map_WhenApprovedOutputReferencesAgent_ThrowsArgumentException()
    {
        var source = Step(WorkflowNodeType.Agent, 0);
        var target = Step(
            WorkflowNodeType.Integration,
            1,
            """{"content":"$.steps[0].approvedOutput"}""");
        var run = Run(source, target);

        var exception = Assert.Throws<ArgumentException>(
            () => mapper.Map(target, [source, target], run));

        Assert.Contains("approval node", exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Map_WhenRegenerationFeedbackExists_AddsEditFeedbackInput()
    {
        var step = Step(WorkflowNodeType.Agent, 0, """{"topic":"$.inputs.topic"}""");
        var run = Run(step);
        run.Inputs["topic"] = "AI";
        run.RegenerationFeedback[step.Id] = "Make it shorter.";

        var result = mapper.Map(step, [step], run);

        Assert.Equal("AI", result["topic"]);
        Assert.Equal("Make it shorter.", result["editFeedback"]);
    }

    private static WorkflowRun Run(params WorkflowStepDefinition[] steps) => new()
    {
        Id = Guid.NewGuid(),
        PresetKey = "test-preset",
        Nodes = steps.Select(step => new WorkflowNodeRun
        {
            NodeId = step.Id,
            NodeKey = step.ReferenceKey,
            DisplayName = step.DisplayName,
            Type = step.Type,
            Status = WorkflowNodeStatus.Idle
        }).ToList()
    };

    private static WorkflowStepDefinition Step(
        WorkflowNodeType type,
        int position,
        string inputMappingJson = "{}") => new()
        {
            Id = Guid.NewGuid(),
            Position = position,
            Type = type,
            ReferenceKey = $"node-{position}",
            DisplayName = $"Node {position}",
            InputMappingJson = inputMappingJson
        };
}
