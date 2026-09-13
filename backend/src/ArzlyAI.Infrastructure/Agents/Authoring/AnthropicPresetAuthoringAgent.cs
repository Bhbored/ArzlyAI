using System.Net;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Domain.Authoring;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class AnthropicPresetAuthoringAgent(
    HttpClient httpClient,
    PresetAuthoringToolExecutor tools) : IPresetAuthoringProviderAgent
{
    private const int MaximumToolRounds = 8;

    public string ProviderKey => AiProviderKeys.Anthropic;

    public async Task<string> ReplyAsync(
        Guid sessionId,
        IReadOnlyList<PresetAuthoringMessage> history,
        string message,
        AuthoringModelSelection model,
        string apiKey,
        int timeoutSeconds,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AnthropicPresetAuthoringAgent.Reply");
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(Math.Max(30, timeoutSeconds)));
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, timeout.Token);
        var messages = new List<object>
        {
            new { role = "user", content = PresetAuthoringPrompt.Build(history, message) }
        };

        for (var round = 0; round < MaximumToolRounds; round++)
        {
            var response = await SendAsync(model.Model, apiKey, messages, linked.Token);
            var toolUses = ToolUses(response.Content);
            if (toolUses.Count == 0)
                return ResponseText(response.Content);

            messages.Add(new { role = "assistant", content = response.Content });
            var results = new List<object>();
            foreach (var toolUse in toolUses)
            {
                var result = await tools.ExecuteAsync(sessionId, toolUse.Name, toolUse.Input, linked.Token);
                results.Add(new { type = "tool_result", tool_use_id = toolUse.Id, content = result });
            }
            messages.Add(new { role = "user", content = results });
        }

        throw new InvalidOperationException("Anthropic exceeded the preset-authoring tool-call limit.");
    }

    private async Task<AnthropicResponse> SendAsync(
        string model,
        string apiKey,
        IReadOnlyList<object> messages,
        CancellationToken cancellationToken)
    {
        var payload = new
        {
            model,
            max_tokens = 8192,
            system = PresetAuthoringPrompt.Instructions,
            messages,
            tools = PresetAuthoringToolDefinitions.All.Select(tool => new
            {
                name = tool.Name,
                description = tool.Description,
                input_schema = PresetAuthoringToolDefinitions.Schema(tool)
            })
        };
        using var request = new HttpRequestMessage(HttpMethod.Post, "v1/messages")
        {
            Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json")
        };
        request.Headers.Add("x-api-key", apiKey);
        request.Headers.Add("anthropic-version", "2023-06-01");
        using var response = await httpClient.SendAsync(request, cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("Anthropic rejected the configured admin-authoring API key.");
        response.EnsureSuccessStatusCode();
        var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync(cancellationToken));
        return new AnthropicResponse(document.RootElement.GetProperty("content").Clone());
    }

    private static IReadOnlyList<ToolUse> ToolUses(JsonElement content) =>
        content.EnumerateArray()
            .Where(block => block.TryGetProperty("type", out var type) && type.GetString() == "tool_use")
            .Select(block => new ToolUse(
                block.GetProperty("id").GetString() ?? throw new InvalidOperationException("Anthropic tool call has no id."),
                block.GetProperty("name").GetString() ?? throw new InvalidOperationException("Anthropic tool call has no name."),
                block.GetProperty("input").Clone()))
            .ToList();

    private static string ResponseText(JsonElement content)
    {
        var text = string.Join('\n', content.EnumerateArray()
            .Where(block => block.TryGetProperty("type", out var type) && type.GetString() == "text")
            .Select(block => block.TryGetProperty("text", out var value) ? value.GetString() : null)
            .Where(value => !string.IsNullOrWhiteSpace(value))!);
        return string.IsNullOrWhiteSpace(text)
            ? throw new InvalidOperationException("Anthropic returned no preset-authoring response.")
            : text.Trim();
    }

    private sealed record AnthropicResponse(JsonElement Content);
    private sealed record ToolUse(string Id, string Name, JsonElement Input);
}
