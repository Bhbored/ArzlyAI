using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed class WorkflowGraphPlanner : IWorkflowGraphPlanner
{
    public IReadOnlyList<WorkflowStepDefinition> Plan(WorkflowDefinition workflow)
    {
        using var operation = Operation.Time("WorkflowGraphPlanner.Plan");
        var steps = workflow.Steps.ToDictionary(step => step.Id);
        if (steps.Count == 0)
            throw new InvalidOperationException($"Workflow '{workflow.Key}' has no nodes.");

        var indegree = steps.Keys.ToDictionary(id => id, _ => 0);
        var outgoing = steps.Keys.ToDictionary(id => id, _ => new List<Guid>());

        foreach (var connection in workflow.Connections)
        {
            if (!steps.ContainsKey(connection.SourceStepId) || !steps.ContainsKey(connection.TargetStepId))
                throw new InvalidOperationException(
                    $"Workflow '{workflow.Key}' contains a connection with a missing node.");
            if (connection.SourceStepId == connection.TargetStepId)
                throw new InvalidOperationException(
                    $"Workflow '{workflow.Key}' contains a self-referencing node.");

            outgoing[connection.SourceStepId].Add(connection.TargetStepId);
            indegree[connection.TargetStepId]++;
        }

        var ready = steps.Values
            .Where(step => indegree[step.Id] == 0)
            .OrderBy(step => step.Position)
            .ThenBy(step => step.Id)
            .ToList();
        var ordered = new List<WorkflowStepDefinition>(steps.Count);

        while (ready.Count > 0)
        {
            var current = ready[0];
            ready.RemoveAt(0);
            ordered.Add(current);

            foreach (var targetId in outgoing[current.Id])
            {
                indegree[targetId]--;
                if (indegree[targetId] != 0) continue;
                ready.Add(steps[targetId]);
                ready.Sort(CompareSteps);
            }
        }

        if (ordered.Count != steps.Count)
            throw new InvalidOperationException($"Workflow '{workflow.Key}' contains a cycle.");

        return ordered;
    }

    private static int CompareSteps(WorkflowStepDefinition left, WorkflowStepDefinition right)
    {
        var positionComparison = left.Position.CompareTo(right.Position);
        return positionComparison != 0 ? positionComparison : left.Id.CompareTo(right.Id);
    }
}
