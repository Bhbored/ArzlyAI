using System.Net;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Authoring;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class GeminiPresetAuthoringAgent(
    HttpClient httpClient,
    PresetAuthoringToolExecutor tools,
    IAuthoringRealtimeNotifier realtime) : IPresetAuthoringProviderAgent
{
    private const int MaximumToolRounds = 8;

    public string ProviderKey => AiProviderKeys.Gemini;

    public async Task<string> ReplyAsync(
        Guid sessionId,
        IReadOnlyList<PresetAuthoringMessage> history,
        string message,
        AuthoringModelSelection model,
        string apiKey,
        int timeoutSeconds,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GeminiPresetAuthoringAgent.Reply");
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(Math.Max(30, timeoutSeconds)));
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, timeout.Token);
        var contents = new List<object>
        {
            new { role = "user", parts = new[] { new { text = PresetAuthoringPrompt.Build(history, message) } } }
        };

        for (var round = 0; round < MaximumToolRounds; round++)
        {
            var response = await SendAsync(sessionId, model.Model, apiKey, contents, linked.Token);
            var functionCalls = FunctionCalls(response.Content);
            if (functionCalls.Count == 0)
                return ResponseText(response.Content);

            contents.Add(new { role = "model", parts = response.Content.GetProperty("parts").Clone() });
            var functionResponses = new List<object>();
            foreach (var call in functionCalls)
            {
                var result = await tools.ExecuteAsync(sessionId, call.Name, call.Arguments, linked.Token);
                using var resultDocument = JsonDocument.Parse(result);
                functionResponses.Add(new
                {
                    functionResponse = new
                    {
                        id = call.Id,
                        name = call.Name,
                        response = new { result = resultDocument.RootElement.Clone() }
                    }
                });
            }
            contents.Add(new { role = "user", parts = functionResponses });
        }

        throw new InvalidOperationException("Gemini exceeded the preset-authoring tool-call limit.");
    }

    private async Task<GeminiResponse> SendAsync(
        Guid sessionId,
        string model,
        string apiKey,
        IReadOnlyList<object> contents,
        CancellationToken cancellationToken)
    {
        var normalizedModel = GeminiCapabilityRules.Normalize(model);
        var payload = new
        {
            systemInstruction = new
            {
                parts = new[] { new { text = PresetAuthoringPrompt.Instructions } }
            },
            contents,
            tools = new[]
            {
                new
                {
                    functionDeclarations = PresetAuthoringToolDefinitions.All.Select(tool => new
                    {
                        name = tool.Name,
                        description = tool.Description,
                        parameters = PresetAuthoringToolDefinitions.Schema(tool)
                    })
                }
            }
        };
        using var request = new HttpRequestMessage(
            HttpMethod.Post,
            $"v1beta/models/{normalizedModel}:streamGenerateContent?alt=sse")
        {
            Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json")
        };
        request.Headers.Add("x-goog-api-key", apiKey);
        using var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new HttpRequestException("Gemini rejected the configured admin-authoring API key.");
        response.EnsureSuccessStatusCode();
        await using var body = await response.Content.ReadAsStreamAsync(cancellationToken);
        var text = new AuthoringTextStream(sessionId, realtime);
        var parts = new List<JsonElement>();
        var finished = false;
        await foreach (var data in AuthoringSseReader.ReadAsync(body, cancellationToken))
        {
            using var chunk = JsonDocument.Parse(data);
            if (chunk.RootElement.TryGetProperty("error", out _))
                throw new HttpRequestException("Gemini streaming request failed.");
            if (!chunk.RootElement.TryGetProperty("candidates", out var candidates) || candidates.GetArrayLength() == 0) continue;
            var candidate = candidates[0];
            if (candidate.TryGetProperty("finishReason", out var finish))
            {
                if (finish.GetString() != "STOP") throw new HttpRequestException("Gemini response was interrupted or blocked.");
                finished = true;
            }
            if (!candidate.TryGetProperty("content", out var content) || !content.TryGetProperty("parts", out var values)) continue;
            foreach (var part in values.EnumerateArray())
            {
                parts.Add(part.Clone());
                if (part.TryGetProperty("text", out var value) &&
                    !(part.TryGetProperty("thought", out var thought) && thought.GetBoolean()))
                    await text.AppendAsync(value.GetString(), cancellationToken);
            }
        }
        if (!finished) throw new HttpRequestException("Gemini response stream ended before completion.");
        return new GeminiResponse(JsonSerializer.SerializeToElement(new { role = "model", parts }));
    }

    private static IReadOnlyList<FunctionCall> FunctionCalls(JsonElement content)
    {
        if (!content.TryGetProperty("parts", out var parts) || parts.ValueKind != JsonValueKind.Array)
            return [];
        return parts.EnumerateArray()
            .Where(part => part.TryGetProperty("functionCall", out _))
            .Select(part =>
            {
                var call = part.GetProperty("functionCall");
                var arguments = call.TryGetProperty("args", out var args)
                    ? args.Clone()
                    : EmptyArguments;
                return new FunctionCall(
                    call.TryGetProperty("id", out var id) ? id.GetString() : null,
                    call.GetProperty("name").GetString() ?? throw new InvalidOperationException("Gemini function call has no name."),
                    arguments);
            }).ToList();
    }

    private static string ResponseText(JsonElement content)
    {
        if (!content.TryGetProperty("parts", out var parts))
            throw new InvalidOperationException("Gemini returned no preset-authoring response.");
        var text = string.Concat(parts.EnumerateArray()
            .Where(part => part.TryGetProperty("text", out _) &&
                !(part.TryGetProperty("thought", out var thought) && thought.GetBoolean()))
            .Select(part => part.GetProperty("text").GetString())
            .Where(value => !string.IsNullOrWhiteSpace(value))!);
        return string.IsNullOrWhiteSpace(text)
            ? throw new InvalidOperationException("Gemini returned no preset-authoring response.")
            : text.Trim();
    }

    private static JsonElement EmptyArguments { get; } = JsonDocument.Parse("{}").RootElement.Clone();

    private sealed record GeminiResponse(JsonElement Content);
    private sealed record FunctionCall(string? Id, string Name, JsonElement Arguments);
}
