using System.Net;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Services.Agents;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Presets;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents;

public sealed class GeminiAgentRuntime(
    HttpClient httpClient,
    ILogger<GeminiAgentRuntime> logger) : IAgentRuntime
{
    public string ProviderKey => AiProviderKeys.Gemini;

    public async Task<string> ExecuteAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GeminiAgentRuntime.Execute");
        var normalizedModel = GeminiCapabilityRules.Normalize(model);
        var modelPath = normalizedModel.StartsWith("models/", StringComparison.OrdinalIgnoreCase)
            ? normalizedModel
            : $"models/{normalizedModel}";
        logger.LogInformation("Executing agent {AgentKey} with model {Model}", definition.Key, normalizedModel);

        var generationConfig = new Dictionary<string, object?>();
        if (temperature is not null)
            generationConfig["temperature"] = temperature.Value;
        if (!string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
        {
            using var schemaDocument = JsonDocument.Parse(definition.OutputSchemaJson);
            generationConfig["responseMimeType"] = "application/json";
            generationConfig["responseSchema"] = schemaDocument.RootElement.Clone();
        }

        var payload = new Dictionary<string, object?>
        {
            ["systemInstruction"] = new
            {
                parts = new[] { new { text = definition.Instructions } }
            },
            ["contents"] = new[]
            {
                new
                {
                    role = "user",
                    parts = new[] { new { text = input } }
                }
            }
        };
        if (generationConfig.Count > 0)
            payload["generationConfig"] = generationConfig;
        if (definition.Harness.WebSearchEnabled)
        {
            payload["tools"] = new[]
            {
                new { googleSearch = new { } }
            };
        }

        using var request = new HttpRequestMessage(
            HttpMethod.Post,
            $"v1beta/{modelPath}:generateContent?key={Uri.EscapeDataString(apiKey)}")
        {
            Content = new StringContent(
                JsonSerializer.Serialize(payload),
                Encoding.UTF8,
                "application/json")
        };
        using var response = await httpClient.SendAsync(request, cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("Gemini rejected the supplied API key.");
        response.EnsureSuccessStatusCode();

        var body = await response.Content.ReadFromJsonAsync<GenerateContentResponse>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("Gemini returned an empty response.");
        var text = body.Candidates?
            .SelectMany(candidate => candidate.Content?.Parts ?? [])
            .Select(part => part.Text)
            .Where(value => !string.IsNullOrWhiteSpace(value))
            .ToArray() ?? [];
        if (text.Length == 0)
            throw new InvalidOperationException($"Agent '{definition.Key}' returned no output.");
        return string.Join('\n', text).Trim();
    }

    private sealed record GenerateContentResponse(
        [property: JsonPropertyName("candidates")] IReadOnlyList<Candidate>? Candidates);

    private sealed record Candidate([property: JsonPropertyName("content")] Content? Content);

    private sealed record Content([property: JsonPropertyName("parts")] IReadOnlyList<Part>? Parts);

    private sealed record Part([property: JsonPropertyName("text")] string? Text);
}
