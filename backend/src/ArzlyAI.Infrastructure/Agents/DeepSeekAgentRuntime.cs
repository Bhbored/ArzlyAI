using System.Net;
using System.Net.Http.Headers;
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

public sealed class DeepSeekAgentRuntime(
    HttpClient httpClient,
    IModelCapabilityPolicy capabilities,
    ILogger<DeepSeekAgentRuntime> logger) : IAgentRuntime
{
    private const int ResponsesMaxOutputTokens = 8192;

    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

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

        return definition.Harness.WebSearchEnabled
            ? await ExecuteResponsesAsync(
                definition,
                input,
                model,
                temperature,
                apiKey,
                cancellationToken)
            : await ExecuteChatCompletionAsync(
                definition,
                input,
                model,
                temperature,
                apiKey,
                cancellationToken);
    }

    private async Task<string> ExecuteChatCompletionAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        var messages = new List<object>
        {
            new { role = "system", content = BuildSystemContent(definition) },
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
            payload["response_format"] = new { type = "json_object" };

        using var request = CreateAuthorizedRequest(HttpMethod.Post, "chat/completions", apiKey);
        request.Content = new StringContent(
            JsonSerializer.Serialize(payload),
            Encoding.UTF8,
            "application/json");
        using var response = await httpClient.SendAsync(request, cancellationToken);
        await EnsureSuccessAsync(response, "DeepSeek", cancellationToken);

        var rawBody = await response.Content.ReadAsStringAsync(cancellationToken);
        var body = JsonSerializer.Deserialize<ChatCompletionResponse>(rawBody, JsonOptions)
            ?? throw new InvalidOperationException("DeepSeek returned an empty response.");
        var content = body.Choices?.FirstOrDefault()?.Message?.Content;
        if (string.IsNullOrWhiteSpace(content))
            throw new InvalidOperationException($"Agent '{definition.Key}' returned no output.");
        return FinalizeStructuredOutput(content.Trim(), definition);
    }

    private async Task<string> ExecuteResponsesAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        if (!capabilities.SupportsWebSearch(ProviderKey, model))
        {
            throw new ArgumentException(
                $"Model '{model}' does not support DeepSeek hosted web search. " +
                "Use deepseek-v4-flash or deepseek-v4-pro.");
        }

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
            var content = await ExecuteResponsePassAsync(
                definition,
                passInput,
                model,
                temperature,
                apiKey,
                cancellationToken);
            evidence.Add(BoundedWebSearchSupport.TruncateEvidence(content.Trim()));
        }

        var finalContent = evidence[^1];
        if (string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
            return finalContent;
        if (BoundedWebSearchSupport.TryExtractJsonObject(finalContent, out var finalJson))
            return finalJson;

        logger.LogInformation(
            "DeepSeek completed {SearchPasses} research passes for schema-backed agent {AgentKey}; " +
            "running a JSON formatting pass.",
            searchPasses,
            definition.Key);
        var formattingInput = BoundedWebSearchSupport.BuildFormattingInput(input, evidence);
        return await ExecuteChatCompletionAsync(
            definition,
            formattingInput,
            model,
            temperature,
            apiKey,
            cancellationToken);
    }

    private async Task<string> ExecuteResponsePassAsync(
        AgentDefinition definition,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken)
    {
        var payload = new Dictionary<string, object?>
        {
            ["model"] = model,
            ["instructions"] = BuildSystemContent(definition),
            ["input"] = input,
            ["max_output_tokens"] = ResponsesMaxOutputTokens,
            ["reasoning"] = new Dictionary<string, string> { ["effort"] = "none" },
            ["tools"] = new[]
            {
                new Dictionary<string, string> { ["type"] = "web_search" }
            },
            ["tool_choice"] = "auto"
        };
        if (temperature is not null)
            payload["temperature"] = temperature.Value;

        using var request = CreateAuthorizedRequest(HttpMethod.Post, "responses", apiKey);
        request.Content = new StringContent(
            JsonSerializer.Serialize(payload),
            Encoding.UTF8,
            "application/json");
        using var response = await httpClient.SendAsync(request, cancellationToken);
        await EnsureSuccessAsync(response, "DeepSeek", cancellationToken);

        var rawBody = await response.Content.ReadAsStringAsync(cancellationToken);
        using var document = JsonDocument.Parse(rawBody);
        var root = document.RootElement;
        EnsureResponseSucceeded(root, definition.Key, rawBody);
        var requiresStructuredOutput = !string.IsNullOrWhiteSpace(definition.OutputSchemaJson);
        var outputText = root.TryGetProperty("output_text", out var outputTextElement) &&
                         outputTextElement.ValueKind == JsonValueKind.String
            ? outputTextElement.GetString()
            : null;
        var content = ExtractResponsesText(outputText, rawBody, requiresStructuredOutput);
        if (string.IsNullOrWhiteSpace(content))
        {
            logger.LogWarning(
                "DeepSeek returned no extractable output for agent {AgentKey}. Body: {Body}",
                definition.Key,
                Truncate(rawBody, 2_000));
            throw new InvalidOperationException(
                $"Agent '{definition.Key}' returned no output. DeepSeek response: {Truncate(rawBody, 500)}");
        }

        return content.Trim();
    }

    private static HttpRequestMessage CreateAuthorizedRequest(
        HttpMethod method,
        string path,
        string apiKey)
    {
        var request = new HttpRequestMessage(method, path);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
        return request;
    }

    private static string BuildSystemContent(AgentDefinition definition)
    {
        if (string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
            return definition.Instructions;
        return
            $"{definition.Instructions}\n\nReturn only valid JSON matching this schema:\n{definition.OutputSchemaJson}";
    }

    private static async Task EnsureSuccessAsync(
        HttpResponseMessage response,
        string provider,
        CancellationToken cancellationToken)
    {
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException($"{provider} rejected the supplied API key.");
        if (response.IsSuccessStatusCode)
            return;
        var body = await response.Content.ReadAsStringAsync(cancellationToken);
        throw new InvalidOperationException(
            $"{provider} request failed with {(int)response.StatusCode} {response.ReasonPhrase}: {body}");
    }

    private static void EnsureResponseSucceeded(
        JsonElement root,
        string agentKey,
        string rawBody)
    {
        var status = root.TryGetProperty("status", out var statusElement)
            ? statusElement.GetString()
            : null;
        if (string.IsNullOrWhiteSpace(status))
            throw new InvalidOperationException("DeepSeek returned an empty response.");
        if (string.Equals(status, "failed", StringComparison.OrdinalIgnoreCase))
        {
            var message = root.TryGetProperty("error", out var errorElement) &&
                          errorElement.TryGetProperty("message", out var messageElement)
                ? messageElement.GetString()
                : null;
            throw new InvalidOperationException($"Agent '{agentKey}' failed: {message ?? "DeepSeek marked the response as failed."}");
        }
        if (string.Equals(status, "incomplete", StringComparison.OrdinalIgnoreCase))
        {
            var reason = root.TryGetProperty("incomplete_details", out var detailsElement) &&
                         detailsElement.TryGetProperty("reason", out var reasonElement)
                ? reasonElement.GetString()
                : null;
            throw new InvalidOperationException(
                $"Agent '{agentKey}' returned an incomplete DeepSeek response ({reason ?? "unknown"}).");
        }
        if (string.Equals(status, "in_progress", StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                $"Agent '{agentKey}' returned an in-progress DeepSeek response. Body: {Truncate(rawBody, 500)}");
        }
    }

    private enum OutputTextSource
    {
        TopLevel,
        Message,
        Reasoning,
        Other
    }

    private static string? ExtractResponsesText(
        string? outputText,
        string rawBody,
        bool requiresStructuredOutput)
    {
        var candidates = CollectOutputTextCandidates(outputText, rawBody);
        if (candidates.Count == 0)
            return null;

        if (!requiresStructuredOutput)
        {
            var messageText = string.Join(
                '\n',
                candidates
                .Where(candidate => candidate.Source == OutputTextSource.Message)
                .Select(candidate => candidate.Text));
            if (!string.IsNullOrWhiteSpace(messageText))
                return messageText;

            var nonReasoningText = string.Join(
                '\n',
                candidates
                    .Where(candidate => candidate.Source != OutputTextSource.Reasoning)
                    .Select(candidate => candidate.Text));
            return string.IsNullOrWhiteSpace(nonReasoningText) ? candidates[0].Text : nonReasoningText;
        }

        var structuredMessageText = string.Join(
            '\n',
            candidates
                .Where(candidate => candidate.Source == OutputTextSource.Message)
                .Select(candidate => candidate.Text));
        if (BoundedWebSearchSupport.TryExtractJsonObject(structuredMessageText, out var messageJson))
            return messageJson;

        foreach (var candidate in candidates)
        {
            if (BoundedWebSearchSupport.TryExtractJsonObject(candidate.Text, out var json))
                return json;
        }

        return string.IsNullOrWhiteSpace(structuredMessageText)
            ? candidates[0].Text
            : structuredMessageText;
    }

    private static List<(OutputTextSource Source, string Text)> CollectOutputTextCandidates(
        string? outputText,
        string rawBody)
    {
        var candidates = new List<(OutputTextSource Source, string Text)>();
        if (!string.IsNullOrWhiteSpace(outputText))
            candidates.Add((OutputTextSource.TopLevel, outputText));

        if (string.IsNullOrWhiteSpace(rawBody))
            return candidates;

        using var document = JsonDocument.Parse(rawBody);
        var root = document.RootElement;
        if (!root.TryGetProperty("output", out var output) || output.ValueKind != JsonValueKind.Array)
            return candidates;

        foreach (var item in output.EnumerateArray())
        {
            var type = item.TryGetProperty("type", out var typeElement)
                ? typeElement.GetString()
                : null;
            if (string.Equals(type, "web_search_call", StringComparison.OrdinalIgnoreCase))
                continue;

            var source = string.Equals(type, "message", StringComparison.OrdinalIgnoreCase)
                ? OutputTextSource.Message
                : string.Equals(type, "reasoning", StringComparison.OrdinalIgnoreCase)
                    ? OutputTextSource.Reasoning
                    : OutputTextSource.Other;

            if (!item.TryGetProperty("content", out var content))
                continue;

            var parts = new List<string>();
            CollectTextParts(content, parts);
            foreach (var part in parts)
                candidates.Add((source, part));
        }

        return candidates;
    }

    private static string FinalizeStructuredOutput(string content, AgentDefinition definition)
    {
        if (string.IsNullOrWhiteSpace(definition.OutputSchemaJson))
            return content;
        if (BoundedWebSearchSupport.TryExtractJsonObject(content, out var json))
            return json;
        throw new InvalidOperationException(
            $"Agent '{definition.Key}' must return JSON but returned plain text.");
    }

    private static void CollectTextParts(JsonElement content, List<string> texts)
    {
        if (content.ValueKind == JsonValueKind.String)
        {
            var value = content.GetString();
            if (!string.IsNullOrWhiteSpace(value))
                texts.Add(value);
            return;
        }

        if (content.ValueKind != JsonValueKind.Array)
            return;

        foreach (var part in content.EnumerateArray())
        {
            if (part.ValueKind == JsonValueKind.String)
            {
                var value = part.GetString();
                if (!string.IsNullOrWhiteSpace(value))
                    texts.Add(value);
                continue;
            }

            if (part.TryGetProperty("text", out var textElement) &&
                textElement.ValueKind == JsonValueKind.String)
            {
                var text = textElement.GetString();
                if (!string.IsNullOrWhiteSpace(text))
                    texts.Add(text);
            }
        }
    }

    private static string Truncate(string value, int maxLength) =>
        value.Length <= maxLength ? value : value[..maxLength];

    private sealed record ChatCompletionResponse(IReadOnlyList<Choice>? Choices);

    private sealed record Choice(Message? Message);

    private sealed record Message(
        [property: JsonPropertyName("content")] string? Content);
}
