using System.Net;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Domain.Authoring;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class AnthropicPresetAuthoringAgent(
    HttpClient httpClient,
    PresetAuthoringToolExecutor tools,
    IAuthoringRealtimeNotifier realtime) : IPresetAuthoringProviderAgent
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
            var response = await SendAsync(sessionId, model.Model, apiKey, messages, linked.Token);
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
        Guid sessionId,
        string model,
        string apiKey,
        IReadOnlyList<object> messages,
        CancellationToken cancellationToken)
    {
        var payload = new
        {
            model,
            stream = true,
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
        using var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new HttpRequestException("Anthropic rejected the configured admin-authoring API key.");
        response.EnsureSuccessStatusCode();
        await using var body = await response.Content.ReadAsStreamAsync(cancellationToken);
        var text = new AuthoringTextStream(sessionId, realtime);
        var blocks = new SortedDictionary<int, JsonObject>();
        var inputs = new Dictionary<int, StringBuilder>();
        var finished = false;
        await foreach (var data in AuthoringSseReader.ReadAsync(body, cancellationToken))
        {
            var chunk = JsonNode.Parse(data)!.AsObject();
            switch (chunk["type"]?.GetValue<string>())
            {
                case "error":
                    throw new HttpRequestException("Anthropic streaming request failed.");
                case "content_block_start":
                    var index = chunk["index"]!.GetValue<int>();
                    blocks[index] = chunk["content_block"]!.DeepClone().AsObject();
                    if (blocks[index]["type"]?.GetValue<string>() == "text")
                        await text.AppendAsync(blocks[index]["text"]?.GetValue<string>(), cancellationToken);
                    break;
                case "content_block_delta":
                    var blockIndex = chunk["index"]!.GetValue<int>();
                    var delta = chunk["delta"]!.AsObject();
                    var block = blocks[blockIndex];
                    switch (delta["type"]?.GetValue<string>())
                    {
                        case "text_delta":
                            var value = delta["text"]!.GetValue<string>();
                            block["text"] = (block["text"]?.GetValue<string>() ?? "") + value;
                            await text.AppendAsync(value, cancellationToken);
                            break;
                        case "input_json_delta":
                            if (!inputs.TryGetValue(blockIndex, out var input)) inputs[blockIndex] = input = new StringBuilder();
                            input.Append(delta["partial_json"]!.GetValue<string>());
                            break;
                        case "thinking_delta":
                            block["thinking"] = (block["thinking"]?.GetValue<string>() ?? "") + delta["thinking"]!.GetValue<string>();
                            break;
                        case "signature_delta":
                            block["signature"] = delta["signature"]!.GetValue<string>();
                            break;
                    }
                    break;
                case "message_delta":
                    if (chunk["delta"]?["stop_reason"]?.GetValue<string>() is "max_tokens" or "refusal")
                        throw new HttpRequestException("Anthropic response was interrupted or exceeded its output limit.");
                    break;
                case "message_stop":
                    finished = true;
                    break;
            }
        }
        if (!finished) throw new HttpRequestException("Anthropic response stream ended before completion.");
        foreach (var (index, input) in inputs) blocks[index]["input"] = JsonNode.Parse(input.ToString());
        return new AnthropicResponse(JsonSerializer.SerializeToElement(blocks.Values));
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
