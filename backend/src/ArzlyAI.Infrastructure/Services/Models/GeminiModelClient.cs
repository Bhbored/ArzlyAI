using System.Net;
using System.Net.Http.Json;
using System.Text.Json.Serialization;
using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Providers;
using ArzlyAI.Application.Services.Models;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Services.Models;

public sealed class GeminiModelClient(
    HttpClient httpClient,
    ILogger<GeminiModelClient> logger) : IProviderModelClient
{
    public string ProviderKey => AiProviderKeys.Gemini;

    public async Task<IReadOnlyList<ProviderModel>> ListAsync(
        string apiKey,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GeminiModelClient.List");
        using var request = new HttpRequestMessage(
            HttpMethod.Get,
            $"v1beta/models?key={Uri.EscapeDataString(apiKey)}");
        using var response = await httpClient.SendAsync(request, cancellationToken);

        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new UnauthorizedAccessException("Gemini rejected the supplied API key.");
        if (!response.IsSuccessStatusCode)
            logger.LogError("Gemini model listing failed with status {StatusCode}", response.StatusCode);
        response.EnsureSuccessStatusCode();

        var payload = await response.Content.ReadFromJsonAsync<ModelsPayload>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("Gemini returned an empty model catalog response.");
        return payload.Models.Select(model => new ProviderModel(
            model.Name,
            "google",
            DateTimeOffset.UtcNow)).ToList();
    }

    private sealed record ModelsPayload(
        [property: JsonPropertyName("models")] IReadOnlyList<ModelPayload> Models);

    private sealed record ModelPayload(string Name);
}
