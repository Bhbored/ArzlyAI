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

public sealed class DeepSeekModelClient(
    HttpClient httpClient,
    ILogger<DeepSeekModelClient> logger) : IProviderModelClient
{
    public string ProviderKey => AiProviderKeys.DeepSeek;

    public async Task<IReadOnlyList<ProviderModel>> ListAsync(
        string apiKey,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("DeepSeekModelClient.List");
        using var request = new HttpRequestMessage(HttpMethod.Get, "models");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
        using var response = await httpClient.SendAsync(request, cancellationToken);

        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("DeepSeek rejected the supplied API key.");
        if (!response.IsSuccessStatusCode)
            logger.LogError("DeepSeek model listing failed with status {StatusCode}", response.StatusCode);
        response.EnsureSuccessStatusCode();

        var payload = await response.Content.ReadFromJsonAsync<ModelsPayload>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("DeepSeek returned an empty model catalog response.");
        return payload.Data.Select(model => new ProviderModel(
            model.Id,
            model.OwnedBy ?? "deepseek",
            DateTimeOffset.FromUnixTimeSeconds(model.Created))).ToList();
    }

    private sealed record ModelsPayload(IReadOnlyList<ModelPayload> Data);

    private sealed record ModelPayload(
        string Id,
        long Created,
        [property: JsonPropertyName("owned_by")] string? OwnedBy);
}
