using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Serialization;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Providers;
using ArzlyAI.Application.Services.Models;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Services.Models;

public sealed class AnthropicModelClient(
    HttpClient httpClient,
    ILogger<AnthropicModelClient> logger) : IProviderModelClient
{
    public string ProviderKey => AiProviderKeys.Anthropic;

    public async Task<IReadOnlyList<ProviderModel>> ListAsync(
        string apiKey,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AnthropicModelClient.List");
        using var request = new HttpRequestMessage(HttpMethod.Get, "v1/models");
        request.Headers.Add("x-api-key", apiKey);
        request.Headers.Add("anthropic-version", "2023-06-01");
        using var response = await httpClient.SendAsync(request, cancellationToken);

        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("Anthropic rejected the supplied API key.");
        if (!response.IsSuccessStatusCode)
            logger.LogError("Anthropic model listing failed with status {StatusCode}", response.StatusCode);
        response.EnsureSuccessStatusCode();

        var payload = await response.Content.ReadFromJsonAsync<ModelsPayload>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("Anthropic returned an empty model catalog response.");
        return payload.Data.Select(model => new ProviderModel(
            model.Id,
            "anthropic",
            model.CreatedAt ?? DateTimeOffset.UtcNow)).ToList();
    }

    private sealed record ModelsPayload(IReadOnlyList<ModelPayload> Data);

    private sealed record ModelPayload(
        string Id,
        [property: JsonPropertyName("created_at")] DateTimeOffset? CreatedAt);
}
