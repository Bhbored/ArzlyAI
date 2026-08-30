using ArzlyAI.Application.Constants;
using ArzlyAI.Application.DTOs.Models;
using ArzlyAI.Application.Security;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Models;

public sealed class ProviderModelCatalogService(
    IEnumerable<IProviderModelClient> clients,
    IModelCapabilityPolicy capabilities,
    ICredentialEnvelopeProtector credentialsProtector,
    ILogger<ProviderModelCatalogService> logger) : IProviderModelCatalogService
{
    private readonly IReadOnlyDictionary<string, IProviderModelClient> clientsByKey =
        clients.ToDictionary(client => client.ProviderKey, StringComparer.OrdinalIgnoreCase);

    public async Task<IReadOnlyList<ProviderModelResponse>> ListAsync(
        string provider,
        ListProviderModelsRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ProviderModelCatalogService.List");
        var normalizedProvider = provider.ToLowerInvariant();
        if (!AiProviderKeys.IsSupported(normalizedProvider))
            throw new ArgumentException($"Provider '{provider}' is not supported.");

        if (!clientsByKey.TryGetValue(normalizedProvider, out var client))
            throw new InvalidOperationException($"No model client is registered for '{provider}'.");

        var credentials = credentialsProtector.Decrypt(request.Credentials);
        var credentialKey = AiProviderKeys.CredentialKey(normalizedProvider);
        var apiKey = credentials.TryGetValue(credentialKey, out var value) &&
                     !string.IsNullOrWhiteSpace(value)
            ? value
            : throw new ArgumentException($"Required credential '{credentialKey}' is missing.");

        var models = await client.ListAsync(apiKey, cancellationToken);
        var response = models
            .Where(model => capabilities.IsUsable(normalizedProvider, model.Id))
            .OrderBy(model => model.Id, StringComparer.OrdinalIgnoreCase)
            .Select(model => new ProviderModelResponse(
                model.Id,
                ToDisplayName(normalizedProvider, model.Id),
                normalizedProvider,
                model.OwnedBy,
                model.CreatedAtUtc,
                capabilities.SupportsTemperature(normalizedProvider, model.Id),
                capabilities.SupportsWebSearch(normalizedProvider, model.Id)))
            .ToList();
        logger.LogInformation(
            "Loaded {ModelCount} usable {Provider} models",
            response.Count,
            normalizedProvider);
        return response;
    }

    private static string ToDisplayName(string provider, string id) =>
        provider switch
        {
            AiProviderKeys.OpenAi => string.Join(' ', id.Split('-', StringSplitOptions.RemoveEmptyEntries)
                .Select(part => part.Equals("gpt", StringComparison.OrdinalIgnoreCase)
                    ? "GPT"
                    : char.ToUpperInvariant(part[0]) + part[1..])),
            AiProviderKeys.Gemini => GeminiCapabilityRules.Normalize(id),
            _ => id
        };
}
