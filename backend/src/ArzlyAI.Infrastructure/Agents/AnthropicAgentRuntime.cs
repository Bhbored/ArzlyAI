using System.Net;
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

public sealed class AnthropicAgentRuntime(
    HttpClient httpClient,
    IModelCapabilityPolicy capabilities,
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

        return definition.Harness.WebSearchEnabled
            ? await ExecuteBoundedWebSearchAsync(
                definition,
                input,
                model,
                temperature,
                apiKey,
                cancellationToken)
            : await ExecuteMessageAsync(
                definition,
                input,
                model,
                temperature,
                apiKey,
                includeWebSearch: false,
                includeSchema: true,
                cancellationToken);
    }

    private async Task<string> ExecuteBoundedWebSearchAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        if (!capabilities.SupportsWebSearch(ProviderKey, model))
            throw new ArgumentException($"Model '{model}' does not support Anthropic hosted web search.");

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
            var content = await ExecuteMessageAsync(
                definition,
                passInput,
                model,
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
            "Anthropic completed {SearchPasses} research passes for schema-backed agent {AgentKey}; " +
            "running a JSON formatting pass.",
            searchPasses,
            definition.Key);
        return await ExecuteMessageAsync(
            definition,
            BoundedWebSearchSupport.BuildFormattingInput(input, evidence),
            model,
            temperature,
            apiKey,
            includeWebSearch: false,
            includeSchema: true,
            cancellationToken);
    }

    private async Task<string> ExecuteMessageAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        bool includeWebSearch,
        bool includeSchema,
        CancellationToken cancellationToken)
    {
        var payload = new Dictionary<string, object?>
        {
            ["model"] = model,
            ["max_tokens"] = 8192,
            ["system"] = BuildSystemContent(definition, includeSchema),
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

        if (includeWebSearch)
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

        var rawBody = await response.Content.ReadAsStringAsync(cancellationToken);
        var body = JsonSerializer.Deserialize<MessageResponse>(rawBody, JsonOptions)
            ?? throw new InvalidOperationException("Anthropic returned an empty response.");
        var text = body.Content
            .Where(part => part.Type == "text")
            .Select(part => part.Text)
            .Where(value => !string.IsNullOrWhiteSpace(value))
            .ToArray();
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

    private sealed record MessageResponse(IReadOnlyList<ContentPart> Content);

    private sealed record ContentPart(
        string Type,
        [property: JsonPropertyName("text")] string? Text);
}
