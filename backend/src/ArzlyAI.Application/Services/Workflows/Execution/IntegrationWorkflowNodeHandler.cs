using ArzlyAI.Application.Integrations;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using SerilogTimings;
using System.Text.Json;

namespace ArzlyAI.Application.Services.Workflows.Execution;

public sealed class IntegrationWorkflowNodeHandler(
    IEnumerable<IIntegrationHandler> integrationHandlers) : IWorkflowNodeHandler
{
    public WorkflowNodeType NodeType => WorkflowNodeType.Integration;
    public bool StartsRunning => true;

    public string RunningMessage(WorkflowStepDefinition step) => $"{step.DisplayName} is running.";

    public async Task<WorkflowNodeExecutionResult> ExecuteAsync(
        WorkflowNodeExecutionContext context,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("IntegrationWorkflowNodeHandler.Execute");
        if (!ShouldExecute(context.Step.ConfigurationJson, context.Inputs))
            return new WorkflowNodeExecutionResult(
                string.Empty,
                WorkflowNodeStatus.Skipped,
                $"{context.Step.DisplayName} skipped.");

        var handler = integrationHandlers.SingleOrDefault(candidate => candidate.Key == context.Step.ReferenceKey)
            ?? throw new InvalidOperationException(
                $"No integration handler is installed for '{context.Step.ReferenceKey}'.");
        var output = await handler.ExecuteAsync(context.Inputs, context.Credentials, cancellationToken);
        return new WorkflowNodeExecutionResult(
            output,
            WorkflowNodeStatus.Completed,
            $"{context.Step.DisplayName} completed.");
    }

    private static bool ShouldExecute(
        string? configurationJson,
        IReadOnlyDictionary<string, string> inputs)
    {
        if (string.IsNullOrWhiteSpace(configurationJson)) return true;
        using var document = JsonDocument.Parse(configurationJson);
        if (!document.RootElement.TryGetProperty("when", out var when)) return true;
        var input = when.GetProperty("input").GetString()
            ?? throw new ArgumentException("Integration condition input is required.");
        var accepted = when.GetProperty("equalsAny").EnumerateArray()
            .Select(item => item.GetString() ?? string.Empty);
        return inputs.TryGetValue(input, out var value) &&
               accepted.Contains(value, StringComparer.OrdinalIgnoreCase);
    }
}
