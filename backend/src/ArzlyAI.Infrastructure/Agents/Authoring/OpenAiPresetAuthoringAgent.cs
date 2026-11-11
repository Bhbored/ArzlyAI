using System.Text.Json;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Domain.Authoring;
using Microsoft.Agents.AI;
using Microsoft.Extensions.AI;
using OpenAI.Responses;
using SerilogTimings;

#pragma warning disable OPENAI001
#pragma warning disable MAAI001
namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class OpenAiPresetAuthoringAgent(
    PresetAuthoringToolExecutor toolExecutor,
    IAuthoringRealtimeNotifier realtime) : IPresetAuthoringProviderAgent
{
    public string ProviderKey => AiProviderKeys.OpenAi;

    public async Task<string> ReplyAsync(
        Guid sessionId,
        IReadOnlyList<PresetAuthoringMessage> history,
        string message,
        AuthoringModelSelection model,
        string apiKey,
        int timeoutSeconds,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("OpenAiPresetAuthoringAgent.Reply");
        var tools = new List<AITool>
        {
            AIFunctionFactory.Create(
                (Func<CancellationToken, Task<string>>)(ct => toolExecutor.ExecuteAsync(
                    sessionId, "list_capabilities", EmptyArguments, ct)),
                "list_capabilities", "List every executable integration and deterministic operation."),
            AIFunctionFactory.Create(
                (Func<string, CancellationToken, Task<string>>)((key, ct) => toolExecutor.ExecuteAsync(
                    sessionId, "get_capability_details", Arguments("key", key), ct)),
                "get_capability_details", "Get authoritative schemas and setup requirements for one capability."),
            AIFunctionFactory.Create(
                (Func<string, CancellationToken, Task<string>>)((draftJson, ct) => toolExecutor.ExecuteAsync(
                    sessionId, "save_preset_draft", Arguments("draftJson", draftJson), ct)),
                "save_preset_draft", "Save the complete typed preset draft JSON and return deterministic validation."),
            AIFunctionFactory.Create(
                (Func<CancellationToken, Task<string>>)(ct => toolExecutor.ExecuteAsync(
                    sessionId, "validate_preset_draft", EmptyArguments, ct)),
                "validate_preset_draft", "Validate the current draft without publishing it.")
        };

        var chatClient = new ResponsesClient(apiKey)
            .AsIChatClientWithStoredOutputDisabled(model.Model);
        var agent = chatClient.AsAIAgent("preset-author", PresetAuthoringPrompt.Instructions,
            "Designs executable ArzlyAI preset graphs.", tools);
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(Math.Max(30, timeoutSeconds)));
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, timeout.Token);
        var stream = new AuthoringTextStream(sessionId, realtime);
        await foreach (var update in agent.RunStreamingAsync(PresetAuthoringPrompt.Build(history, message), cancellationToken: linked.Token))
            await stream.AppendAsync(update.Text, linked.Token);
        var text = string.IsNullOrWhiteSpace(stream.ToString())
            ? throw new InvalidOperationException("The preset authoring agent returned no response.")
            : stream.ToString().Trim();
        return text;
    }

    private static JsonElement EmptyArguments { get; } = JsonDocument.Parse("{}").RootElement.Clone();

    private static JsonElement Arguments(string name, string value)
    {
        using var document = JsonDocument.Parse(JsonSerializer.Serialize(new Dictionary<string, string> { [name] = value }));
        return document.RootElement.Clone();
    }
}
#pragma warning restore OPENAI001
#pragma warning restore MAAI001
