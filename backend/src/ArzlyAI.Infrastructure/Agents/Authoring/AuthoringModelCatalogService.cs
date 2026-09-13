using ArzlyAI.Application.Constants;
using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Application.Services.Models;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class AuthoringModelCatalogService(
    IEnumerable<IProviderModelClient> clients,
    IModelCapabilityPolicy capabilities,
    IOptions<PresetAuthoringOptions> options,
    ILogger<AuthoringModelCatalogService> logger) : IAuthoringModelCatalogService
{
    private readonly IReadOnlyDictionary<string, IProviderModelClient> clientsByProvider =
        clients.ToDictionary(client => client.ProviderKey, StringComparer.OrdinalIgnoreCase);

    public async Task<IReadOnlyList<AuthoringModelResponse>> ListAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AuthoringModelCatalogService.List");
        var settings = options.Value;
        var models = new List<AuthoringModelResponse>();

        foreach (var provider in AiProviderKeys.All)
        {
            if (!settings.TryGetConfiguredProvider(provider, out var providerSettings) ||
                !clientsByProvider.TryGetValue(provider, out var client))
                continue;

            try
            {
                var discovered = await client.ListAsync(providerSettings.ApiKey, cancellationToken);
                models.AddRange(discovered
                    .Where(model => capabilities.IsUsable(provider, model.Id))
                    .Where(model => capabilities.SupportsToolCalling(provider, model.Id))
                    .Select(model => new AuthoringModelResponse(
                        provider,
                        NormalizeModel(provider, model.Id),
                        ToDisplayName(provider, model.Id),
                        capabilities.SupportsTemperature(provider, model.Id),
                        capabilities.SupportsWebSearch(provider, model.Id),
                        IsDefault(settings, provider, model.Id))));
            }
            catch (Exception exception) when (exception is not OperationCanceledException)
            {
                logger.LogWarning(exception,
                    "Could not load authoring models for configured provider {Provider}", provider);
            }
        }

        return models.OrderBy(model => model.Provider, StringComparer.Ordinal)
            .ThenBy(model => model.Model, StringComparer.OrdinalIgnoreCase)
            .ToList();
    }

    public async Task<AuthoringModelSelection> ResolveAsync(
        string provider,
        string model,
        CancellationToken cancellationToken)
    {
        var normalizedProvider = provider.Trim().ToLowerInvariant();
        var normalizedModel = NormalizeModel(normalizedProvider, model.Trim());
        if (!AiProviderKeys.IsSupported(normalizedProvider))
            throw new ArgumentException($"Provider '{provider}' is not supported for admin authoring.");

        var available = await ListAsync(cancellationToken);
        if (!available.Any(candidate =>
                string.Equals(candidate.Provider, normalizedProvider, StringComparison.OrdinalIgnoreCase) &&
                string.Equals(candidate.Model, normalizedModel, StringComparison.OrdinalIgnoreCase)))
            throw new ArgumentException(
                $"Model '{model}' is unavailable, unconfigured, or lacks required function-calling support.");

        return new AuthoringModelSelection(normalizedProvider, normalizedModel);
    }

    public AuthoringModelSelection GetDefaultSelection()
    {
        var settings = options.Value;
        return new AuthoringModelSelection(
            settings.DefaultProvider.Trim().ToLowerInvariant(),
            NormalizeModel(settings.DefaultProvider, settings.DefaultModel));
    }

    private static bool IsDefault(PresetAuthoringOptions settings, string provider, string model) =>
        string.Equals(settings.DefaultProvider, provider, StringComparison.OrdinalIgnoreCase) &&
        string.Equals(NormalizeModel(provider, settings.DefaultModel), NormalizeModel(provider, model),
            StringComparison.OrdinalIgnoreCase);

    private static string NormalizeModel(string provider, string model) =>
        string.Equals(provider, AiProviderKeys.Gemini, StringComparison.OrdinalIgnoreCase)
            ? GeminiCapabilityRules.Normalize(model)
            : model;

    private static string ToDisplayName(string provider, string model) =>
        string.Equals(provider, AiProviderKeys.Gemini, StringComparison.OrdinalIgnoreCase)
            ? GeminiCapabilityRules.Normalize(model)
            : model;
}
