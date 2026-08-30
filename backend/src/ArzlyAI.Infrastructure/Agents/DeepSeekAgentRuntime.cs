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

public sealed class DeepSeekAgentRuntime(
    HttpClient httpClient,
    ILogger<DeepSeekAgentRuntime> logger) : IAgentRuntime
{
    public string ProviderKey => AiProviderKeys.DeepSeek;

    public async Task<string> ExecuteAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("DeepSeekAgentRuntime.Execute");
        logger.LogInformation("Executing agent {AgentKey} with model {Model}", definition.Key, model);

        var messages = new List<object>
        {
            new { role = "system", content = definition.Instructions },
            new { role = "user", content = input }
        };
        var payload = new Dictionary<string, object?>
        {
            ["model"] = model,
            ["messages"] = messages
        };
        if (temperature is not null)
            payload["temperature"] = temperature.Value;
        if (!string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
        {
            using var schemaDocument = JsonDocument.Parse(definition.OutputSchemaJson);
            payload["response_format"] = new
            {
                type = "json_schema",
                json_schema = new
                {
                    name = $"{definition.Key}-output",
                    schema = schemaDocument.RootElement.Clone()
                }
            };
        }

        using var request = new HttpRequestMessage(HttpMethod.Post, "chat/completions");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
        request.Content = new StringContent(
            JsonSerializer.Serialize(payload),
            Encoding.UTF8,
            "application/json");
        using var response = await httpClient.SendAsync(request, cancellationToken);
        response.EnsureSuccessStatusCode();

        var body = await response.Content.ReadFromJsonAsync<ChatCompletionResponse>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("DeepSeek returned an empty response.");
        var content = body.Choices?.FirstOrDefault()?.Message?.Content;
        if (string.IsNullOrWhiteSpace(content))
            throw new InvalidOperationException($"Agent '{definition.Key}' returned no output.");
        return content.Trim();
    }

    private sealed record ChatCompletionResponse(IReadOnlyList<Choice>? Choices);

    private sealed record Choice(Message? Message);

    private sealed record Message(
        [property: JsonPropertyName("content")] string? Content);
}
