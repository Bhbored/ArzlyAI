using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Domain.Authoring;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class DeepSeekPresetAuthoringAgent(
    HttpClient httpClient,
    PresetAuthoringToolExecutor tools) : IPresetAuthoringProviderAgent
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
            var response = await SendAsync(model.Model, apiKey, messages, linked.Token);
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
        string model,
        string apiKey,
        IReadOnlyList<object> messages,
        CancellationToken cancellationToken)
    {
        var payload = new
        {
            model,
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
        using var response = await httpClient.SendAsync(request, cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("DeepSeek rejected the configured admin-authoring API key.");
        response.EnsureSuccessStatusCode();
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync(cancellationToken));
        return new DeepSeekResponse(document.RootElement.GetProperty("choices")[0].GetProperty("message").Clone());
    }

    private static IReadOnlyList<ToolCall> ToolCalls(JsonElement message)
    {
        if (!message.TryGetProperty("tool_calls", out var calls) || calls.ValueKind != JsonValueKind.Array)
            return [];
        return calls.EnumerateArray().Select(call =>
        {
            var function = call.GetProperty("function");
            var arguments = function.GetProperty("arguments").GetString() ?? "{}";
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
