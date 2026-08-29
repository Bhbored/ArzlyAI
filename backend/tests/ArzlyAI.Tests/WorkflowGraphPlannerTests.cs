using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Tests;

public sealed class WorkflowGraphPlannerTests
{
    private readonly WorkflowGraphPlanner planner = new();

    [Fact]
    public void Plan_WhenGraphIsValid_ReturnsTopologicalOrder()
    {
        var first = Step(2);
        var second = Step(0);
        var third = Step(1);
        var workflow = Workflow(
            [first, second, third],
            [Connection(second, third), Connection(third, first)]);

        var result = planner.Plan(workflow);

        Assert.Equal([second.Id, third.Id, first.Id], result.Select(step => step.Id));
    }

    [Fact]
    public void Plan_WhenIndependentNodesExist_UsesPositionForDeterministicOrder()
    {
        var later = Step(10);
        var earlier = Step(1);

        var result = planner.Plan(Workflow([later, earlier], []));

        Assert.Equal([earlier.Id, later.Id], result.Select(step => step.Id));
    }

    [Fact]
    public void Plan_WhenGraphContainsCycle_ThrowsInvalidOperationException()
    {
        var first = Step(0);
        var second = Step(1);
        var workflow = Workflow(
            [first, second],
            [Connection(first, second), Connection(second, first)]);

        var exception = Assert.Throws<InvalidOperationException>(() => planner.Plan(workflow));

        Assert.Contains("cycle", exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Plan_WhenConnectionReferencesMissingNode_ThrowsInvalidOperationException()
    {
        var step = Step(0);
        var workflow = Workflow(
            [step],
            [new WorkflowConnectionDefinition
            {
                Id = Guid.NewGuid(),
                SourceStepId = step.Id,
                TargetStepId = Guid.NewGuid()
            }]);

        var exception = Assert.Throws<InvalidOperationException>(() => planner.Plan(workflow));

        Assert.Contains("missing node", exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    private static WorkflowDefinition Workflow(
        ICollection<WorkflowStepDefinition> steps,
        ICollection<WorkflowConnectionDefinition> connections) => new()
    {
        Id = Guid.NewGuid(),
        Key = "test-workflow",
        Steps = steps,
        Connections = connections
    };

    private static WorkflowStepDefinition Step(int position) => new()
    {
        Id = Guid.NewGuid(),
        Position = position,
        Type = WorkflowNodeType.Agent,
        ReferenceKey = $"agent-{position}",
        DisplayName = $"Agent {position}",
        InputMappingJson = "{}"
    };

    private static WorkflowConnectionDefinition Connection(
        WorkflowStepDefinition source,
        WorkflowStepDefinition target) => new()
    {
        Id = Guid.NewGuid(),
        SourceStepId = source.Id,
        TargetStepId = target.Id
    };
}
