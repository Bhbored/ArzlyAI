using ArzlyAI.Application.Services.Agents;
using ArzlyAI.Domain.Presets;
using Microsoft.Agents.AI;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging;
using OpenAI.Responses;
using SerilogTimings;

#pragma warning disable OPENAI001
#pragma warning disable MAAI001
namespace ArzlyAI.Infrastructure.Agents;

public sealed class OpenAiAgentRuntime(
    ILogger<OpenAiAgentRuntime> logger) : IAgentRuntime
{
    public async Task<string> ExecuteAsync(AgentDefinition definition, string input, string model,
        double? temperature, string apiKey, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("OpenAiAgentRuntime.Execute");
        logger.LogInformation("Executing agent {AgentKey} with model {Model}", definition.Key, model);
        var chatClient = new ResponsesClient(apiKey).AsIChatClientWithStoredOutputDisabled(model);
        var chatOptions = new ChatOptions
        {
            Instructions = definition.Instructions
        };
        if (temperature is not null)
            chatOptions.Temperature = (float)temperature.Value;

        var agent = chatClient.AsHarnessAgent(new HarnessAgentOptions
        {
            Name = definition.Key,
            ChatOptions = chatOptions,
            DisableAgentModeProvider = !definition.Harness.PlanningEnabled,
            DisableTodoProvider = !definition.Harness.TodoTrackingEnabled,
            DisableCompaction = !definition.Harness.ContextCompactionEnabled,
            DisableToolAutoApproval = definition.Harness.RequireToolApproval,
            MaximumIterationsPerRequest = definition.Harness.MaxIterations,
            DisableFileMemory = true,
            DisableWebSearch = true,
            DisableAgentSkillsProvider = true
        });
        var response = await agent.RunAsync(input, cancellationToken: cancellationToken);
        var output = string.IsNullOrWhiteSpace(response.Text)
            ? throw new InvalidOperationException($"Agent '{definition.Key}' returned no output.")
            : response.Text.Trim();
        logger.LogInformation("Agent {AgentKey} completed", definition.Key);
        return output;
    }
}
#pragma warning restore MAAI001
#pragma warning restore OPENAI001
