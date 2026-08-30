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

public sealed class OpenAiModelClient(
    HttpClient httpClient,
    ILogger<OpenAiModelClient> logger) : IProviderModelClient
{
    public string ProviderKey => AiProviderKeys.OpenAi;

    public async Task<IReadOnlyList<ProviderModel>> ListAsync(
        string apiKey,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("OpenAiModelClient.List");
        using var request = new HttpRequestMessage(HttpMethod.Get, "v1/models");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
        using var response = await httpClient.SendAsync(request, cancellationToken);

        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("OpenAI rejected the supplied API key.");
        if (!response.IsSuccessStatusCode)
            logger.LogError("OpenAI model listing failed with status {StatusCode}", response.StatusCode);
        response.EnsureSuccessStatusCode();

        var payload = await response.Content.ReadFromJsonAsync<ModelsPayload>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("OpenAI returned an empty model catalog response.");
        return payload.Data.Select(model => new ProviderModel(
            model.Id,
            model.OwnedBy,
            DateTimeOffset.FromUnixTimeSeconds(model.Created))).ToList();
    }

    private sealed record ModelsPayload(IReadOnlyList<ModelPayload> Data);

    private sealed record ModelPayload(
        string Id,
        long Created,
        [property: JsonPropertyName("owned_by")] string OwnedBy);
}
