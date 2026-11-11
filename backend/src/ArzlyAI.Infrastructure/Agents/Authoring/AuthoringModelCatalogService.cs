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

    public async Task<IReadOnlyList<AuthoringProviderResponse>> ListProvidersAsync(
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AuthoringModelCatalogService.ListProviders");
        var settings = options.Value;
        var providers = new List<AuthoringProviderResponse>();

        foreach (var provider in AiProviderKeys.All)
        {
            var providerSettings = ProviderSettings(settings, provider);
            var hasApiKey = !string.IsNullOrWhiteSpace(providerSettings.ApiKey);
            if (!providerSettings.Enabled || !hasApiKey)
            {
                providers.Add(ProviderResponse(
                    provider,
                    hasApiKey,
                    providerSettings.Enabled,
                    false,
                    providerSettings.Enabled ? "missing_api_key" : "provider_disabled",
                    []));
                continue;
            }

            if (!clientsByProvider.TryGetValue(provider, out var client))
            {
                providers.Add(ProviderResponse(
                    provider, true, true, false, "model_client_unavailable", []));
                continue;
            }

            try
            {
                var discovered = await client.ListAsync(providerSettings.ApiKey, cancellationToken);
                var models = discovered
                    .Where(model => capabilities.IsUsable(provider, model.Id))
                    .Select(model => new AuthoringModelResponse(
                        provider,
                        NormalizeModel(provider, model.Id),
                        ToDisplayName(provider, model.Id),
                        capabilities.SupportsToolCalling(provider, model.Id),
                        capabilities.SupportsTemperature(provider, model.Id),
                        capabilities.SupportsWebSearch(provider, model.Id),
                        capabilities.SupportsToolCalling(provider, model.Id),
                        IsDefault(settings, provider, model.Id)))
                    .OrderBy(model => model.Model, StringComparer.OrdinalIgnoreCase)
                    .ToList();
                var isAvailable = models.Any(model => model.IsAvailable);
                providers.Add(ProviderResponse(
                    provider,
                    true,
                    true,
                    isAvailable,
                    isAvailable ? null : "no_function_calling_models",
                    models));
            }
            catch (Exception exception) when (exception is not OperationCanceledException)
            {
                logger.LogWarning(exception,
                    "Could not load authoring models for configured provider {Provider}", provider);
                providers.Add(ProviderResponse(
                    provider, true, true, false, "model_catalog_unavailable", []));
            }
        }

        return providers;
    }

    public async Task<IReadOnlyList<AuthoringModelResponse>> ListAsync(
        CancellationToken cancellationToken) =>
        (await ListProvidersAsync(cancellationToken))
        .SelectMany(provider => provider.Models)
        .Where(model => model.IsAvailable)
        .ToList();

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

    private static PresetAuthoringProviderOptions ProviderSettings(
        PresetAuthoringOptions settings,
        string provider) =>
        settings.Providers.FirstOrDefault(candidate =>
            string.Equals(candidate.Key, provider, StringComparison.OrdinalIgnoreCase)).Value ?? new();

    private static AuthoringProviderResponse ProviderResponse(
        string provider,
        bool hasApiKey,
        bool isEnabled,
        bool isAvailable,
        string? unavailableReason,
        IReadOnlyList<AuthoringModelResponse> models) =>
        new(
            provider,
            ProviderDisplayName(provider),
            ProviderIconKey(provider),
            hasApiKey,
            isEnabled,
            isAvailable,
            unavailableReason,
            models);

    private static string ProviderDisplayName(string provider) => provider switch
    {
        AiProviderKeys.OpenAi => "OpenAI",
        AiProviderKeys.Anthropic => "Anthropic",
        AiProviderKeys.Gemini => "Google Gemini",
        AiProviderKeys.DeepSeek => "DeepSeek",
        _ => provider
    };

    private static string ProviderIconKey(string provider) => provider switch
    {
        AiProviderKeys.Gemini => "google-gemini",
        _ => provider
    };

    private static string NormalizeModel(string provider, string model) =>
        string.Equals(provider, AiProviderKeys.Gemini, StringComparison.OrdinalIgnoreCase)
            ? GeminiCapabilityRules.Normalize(model)
            : model;

    private static string ToDisplayName(string provider, string model) =>
        string.Equals(provider, AiProviderKeys.Gemini, StringComparison.OrdinalIgnoreCase)
            ? GeminiCapabilityRules.Normalize(model)
            : model;
}
