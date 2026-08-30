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
    IModelCapabilityPolicy capabilities,
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

        return definition.Harness.WebSearchEnabled
            ? await ExecuteBoundedWebSearchAsync(
                definition,
                input,
                normalizedModel,
                modelPath,
                temperature,
                apiKey,
                cancellationToken)
            : await ExecuteGenerateContentAsync(
                definition,
                input,
                modelPath,
                temperature,
                apiKey,
                includeWebSearch: false,
                includeSchema: true,
                cancellationToken);
    }

    private async Task<string> ExecuteBoundedWebSearchAsync(
        AgentDefinition definition,
        string input,
        string normalizedModel,
        string modelPath,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        if (!capabilities.SupportsWebSearch(ProviderKey, normalizedModel))
            throw new ArgumentException($"Model '{normalizedModel}' does not support Gemini hosted web search.");

        var searchPasses = BoundedWebSearchSupport.SearchPassCount(definition.Harness.MaxIterations);
        var evidence = new List<string>(searchPasses);
        for (var pass = 0; pass < searchPasses; pass++)
        {
            cancellationToken.ThrowIfCancellationRequested();
            var passInput = pass == 0
                ? input
                : BoundedWebSearchSupport.BuildFollowUpResearchInput(
                    input,
                    evidence,
                    pass + 1,
                    searchPasses);
            var content = await ExecuteGenerateContentAsync(
                definition,
                passInput,
                modelPath,
                temperature,
                apiKey,
                includeWebSearch: true,
                includeSchema: false,
                cancellationToken);
            evidence.Add(BoundedWebSearchSupport.TruncateEvidence(content));
        }

        var finalContent = evidence[^1];
        if (string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
            return finalContent;
        if (BoundedWebSearchSupport.TryExtractJsonObject(finalContent, out var finalJson))
            return finalJson;

        logger.LogInformation(
            "Gemini completed {SearchPasses} research passes for schema-backed agent {AgentKey}; " +
            "running a JSON formatting pass.",
            searchPasses,
            definition.Key);
        return await ExecuteGenerateContentAsync(
            definition,
            BoundedWebSearchSupport.BuildFormattingInput(input, evidence),
            modelPath,
            temperature,
            apiKey,
            includeWebSearch: false,
            includeSchema: true,
            cancellationToken);
    }

    private async Task<string> ExecuteGenerateContentAsync(
        AgentDefinition definition,
        string input,
        string modelPath,
        double? temperature,
        string apiKey,
        bool includeWebSearch,
        bool includeSchema,
        CancellationToken cancellationToken)
    {
        var generationConfig = new Dictionary<string, object?>();
        if (temperature is not null)
            generationConfig["temperature"] = temperature.Value;
        if (includeSchema && !string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
        {
            using var schemaDocument = JsonDocument.Parse(definition.OutputSchemaJson);
            generationConfig["responseMimeType"] = "application/json";
            generationConfig["responseSchema"] = schemaDocument.RootElement.Clone();
        }

        var payload = new Dictionary<string, object?>
        {
            ["systemInstruction"] = new
            {
                parts = new[] { new { text = BuildSystemContent(definition, includeSchema) } }
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
        if (includeWebSearch)
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

        var rawBody = await response.Content.ReadAsStringAsync(cancellationToken);
        var body = JsonSerializer.Deserialize<GenerateContentResponse>(rawBody, JsonOptions)
            ?? throw new InvalidOperationException("Gemini returned an empty response.");
        var text = body.Candidates?
            .SelectMany(candidate => candidate.Content?.Parts ?? [])
            .Select(part => part.Text)
            .Where(value => !string.IsNullOrWhiteSpace(value))
            .ToArray() ?? [];
        if (text.Length == 0)
            throw new InvalidOperationException($"Agent '{definition.Key}' returned no output.");
        var content = string.Join('\n', text).Trim();
        if (!includeSchema || string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
            return content;
        if (BoundedWebSearchSupport.TryExtractJsonObject(content, out var json))
            return json;
        throw new InvalidOperationException(
            $"Agent '{definition.Key}' must return JSON but returned plain text.");
    }

    private static string BuildSystemContent(AgentDefinition definition, bool includeSchema) =>
        includeSchema && !string.IsNullOrWhiteSpace(definition.OutputSchemaJson)
            ? $"{definition.Instructions}\n\nReturn only valid JSON matching this schema:\n{definition.OutputSchemaJson}"
            : definition.Instructions;

    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    private sealed record GenerateContentResponse(
        [property: JsonPropertyName("candidates")] IReadOnlyList<Candidate>? Candidates);

    private sealed record Candidate([property: JsonPropertyName("content")] Content? Content);

    private sealed record Content([property: JsonPropertyName("parts")] IReadOnlyList<Part>? Parts);

    private sealed record Part([property: JsonPropertyName("text")] string? Text);
}
