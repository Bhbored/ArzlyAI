using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Services.Agents;
using ArzlyAI.Domain.Presets;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents;

public sealed class AnthropicAgentRuntime(
    HttpClient httpClient,
    ILogger<AnthropicAgentRuntime> logger) : IAgentRuntime
{
    public string ProviderKey => AiProviderKeys.Anthropic;

    public async Task<string> ExecuteAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AnthropicAgentRuntime.Execute");
        logger.LogInformation("Executing agent {AgentKey} with model {Model}", definition.Key, model);

        var payload = new Dictionary<string, object?>
        {
            ["model"] = model,
            ["max_tokens"] = 8192,
            ["system"] = definition.Instructions,
            ["messages"] = new[]
            {
                new Dictionary<string, string>
                {
                    ["role"] = "user",
                    ["content"] = input
                }
            }
        };
        if (temperature is not null)
            payload["temperature"] = temperature.Value;

        if (definition.Harness.WebSearchEnabled)
        {
            payload["tools"] = new[]
            {
                new Dictionary<string, string> { ["type"] = "web_search" }
            };
        }

        using var request = new HttpRequestMessage(HttpMethod.Post, "v1/messages");
        request.Headers.Add("x-api-key", apiKey);
        request.Headers.Add("anthropic-version", "2023-06-01");
        request.Content = new StringContent(
            JsonSerializer.Serialize(payload),
            Encoding.UTF8,
            "application/json");
        using var response = await httpClient.SendAsync(request, cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("Anthropic rejected the supplied API key.");
        response.EnsureSuccessStatusCode();

        var body = await response.Content.ReadFromJsonAsync<MessageResponse>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("Anthropic returned an empty response.");
        var text = body.Content
            .Where(part => part.Type == "text")
            .Select(part => part.Text)
            .Where(value => !string.IsNullOrWhiteSpace(value))
            .ToArray();
        if (text.Length == 0)
            throw new InvalidOperationException($"Agent '{definition.Key}' returned no output.");
        return string.Join('\n', text).Trim();
    }

    private sealed record MessageResponse(IReadOnlyList<ContentPart> Content);

    private sealed record ContentPart(
        string Type,
        [property: JsonPropertyName("text")] string? Text);
}
