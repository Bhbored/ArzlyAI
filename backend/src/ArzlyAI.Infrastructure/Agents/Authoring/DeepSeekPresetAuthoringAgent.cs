using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Domain.Authoring;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class DeepSeekPresetAuthoringAgent(
    HttpClient httpClient,
    PresetAuthoringToolExecutor tools,
    IAuthoringRealtimeNotifier realtime) : IPresetAuthoringProviderAgent
{
    private const int MaximumToolRounds = 8;

    public string ProviderKey => AiProviderKeys.DeepSeek;

    public async Task<string> ReplyAsync(
        Guid sessionId,
        IReadOnlyList<PresetAuthoringMessage> history,
        string message,
        AuthoringModelSelection model,
        string apiKey,
        int timeoutSeconds,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("DeepSeekPresetAuthoringAgent.Reply");
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(Math.Max(30, timeoutSeconds)));
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, timeout.Token);
        var messages = new List<object>
        {
            new { role = "system", content = PresetAuthoringPrompt.Instructions },
            new { role = "user", content = PresetAuthoringPrompt.Build(history, message) }
        };

        for (var round = 0; round < MaximumToolRounds; round++)
        {
            var response = await SendAsync(sessionId, model.Model, apiKey, messages, linked.Token);
            var toolCalls = ToolCalls(response.Message);
            if (toolCalls.Count == 0)
                return ResponseText(response.Message);

            messages.Add(response.Message);
            foreach (var call in toolCalls)
            {
                var result = await tools.ExecuteAsync(sessionId, call.Name, call.Arguments, linked.Token);
                messages.Add(new { role = "tool", tool_call_id = call.Id, content = result });
            }
        }

        throw new InvalidOperationException("DeepSeek exceeded the preset-authoring tool-call limit.");
    }

    private async Task<DeepSeekResponse> SendAsync(
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
            messages,
            tools = PresetAuthoringToolDefinitions.All.Select(tool => new
            {
                type = "function",
                function = new
                {
                    name = tool.Name,
                    description = tool.Description,
                    parameters = PresetAuthoringToolDefinitions.Schema(tool)
                }
            }),
            tool_choice = "auto"
        };
        using var request = new HttpRequestMessage(HttpMethod.Post, "chat/completions")
        {
            Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json")
        };
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
        using var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new HttpRequestException("DeepSeek rejected the configured admin-authoring API key.");
        response.EnsureSuccessStatusCode();
        await using var body = await response.Content.ReadAsStreamAsync(cancellationToken);
        var text = new AuthoringTextStream(sessionId, realtime);
        var reasoning = new StringBuilder();
        var calls = new SortedDictionary<int, JsonObject>();
        var finished = false;
        await foreach (var data in AuthoringSseReader.ReadAsync(body, cancellationToken))
        {
            if (data == "[DONE]") break;
            using var chunk = JsonDocument.Parse(data);
            if (chunk.RootElement.TryGetProperty("error", out _))
                throw new HttpRequestException("DeepSeek streaming request failed.");
            if (!chunk.RootElement.TryGetProperty("choices", out var choices) || choices.GetArrayLength() == 0) continue;
            var choice = choices[0];
            if (choice.TryGetProperty("finish_reason", out var finish) && finish.ValueKind == JsonValueKind.String)
            {
                if (finish.GetString() is not ("stop" or "tool_calls"))
                    throw new HttpRequestException("DeepSeek response was interrupted or exceeded its output limit.");
                finished = true;
            }
            if (!choice.TryGetProperty("delta", out var delta)) continue;
            if (delta.TryGetProperty("content", out var content))
                await text.AppendAsync(content.GetString(), cancellationToken);
            if (delta.TryGetProperty("reasoning_content", out var thought)) reasoning.Append(thought.GetString());
            if (!delta.TryGetProperty("tool_calls", out var fragments)) continue;
            foreach (var fragment in fragments.EnumerateArray())
            {
                var index = fragment.GetProperty("index").GetInt32();
                if (!calls.TryGetValue(index, out var call))
                    calls[index] = call = new JsonObject { ["type"] = "function", ["function"] = new JsonObject { ["name"] = "", ["arguments"] = "" } };
                if (fragment.TryGetProperty("id", out var id)) call["id"] = id.GetString();
                if (!fragment.TryGetProperty("function", out var function)) continue;
                var target = call["function"]!.AsObject();
                foreach (var field in new[] { "name", "arguments" })
                    if (function.TryGetProperty(field, out var value))
                        target[field] = target[field]!.GetValue<string>() + value.GetString();
            }
        }
        if (!finished) throw new HttpRequestException("DeepSeek response stream ended before completion.");
        var result = new JsonObject { ["role"] = "assistant", ["content"] = text.ToString() };
        if (reasoning.Length > 0) result["reasoning_content"] = reasoning.ToString();
        if (calls.Count > 0) result["tool_calls"] = new JsonArray(calls.Values.Select(call => (JsonNode)call).ToArray());
        return new DeepSeekResponse(JsonSerializer.SerializeToElement(result));
    }

    private static IReadOnlyList<ToolCall> ToolCalls(JsonElement message)
    {
        if (!message.TryGetProperty("tool_calls", out var calls) || calls.ValueKind != JsonValueKind.Array)
            return [];
        return calls.EnumerateArray().Select(call =>
        {
            var function = call.GetProperty("function");
            var argumentsValue = function.TryGetProperty("arguments", out var rawArguments)
                ? rawArguments
                : default;
            var arguments = argumentsValue.ValueKind switch
            {
                JsonValueKind.String => argumentsValue.GetString(),
                JsonValueKind.Undefined or JsonValueKind.Null => null,
                _ => argumentsValue.GetRawText()
            };
            if (string.IsNullOrWhiteSpace(arguments))
                arguments = "{}";
            using var document = JsonDocument.Parse(arguments);
            return new ToolCall(
                call.GetProperty("id").GetString() ?? throw new InvalidOperationException("DeepSeek tool call has no id."),
                function.GetProperty("name").GetString() ?? throw new InvalidOperationException("DeepSeek tool call has no name."),
                document.RootElement.Clone());
        }).ToList();
    }

    private static string ResponseText(JsonElement message)
    {
        var text = message.TryGetProperty("content", out var content) ? content.GetString() : null;
        return string.IsNullOrWhiteSpace(text)
            ? throw new InvalidOperationException("DeepSeek returned no preset-authoring response.")
            : text.Trim();
    }

    private sealed record DeepSeekResponse(JsonElement Message);
    private sealed record ToolCall(string Id, string Name, JsonElement Arguments);
}
