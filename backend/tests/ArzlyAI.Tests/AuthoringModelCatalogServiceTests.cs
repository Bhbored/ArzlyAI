using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Models.Providers;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Infrastructure.Agents.Authoring;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace ArzlyAI.Tests;

public sealed class AuthoringModelCatalogServiceTests
{
    [Fact]
    public async Task ListAsync_WhenModelsLackToolSupport_ExcludesThem()
    {
        var service = CreateService(
            new ProviderModel("gpt-5-mini", "openai", DateTimeOffset.UtcNow),
            new ProviderModel("whisper-1", "openai", DateTimeOffset.UtcNow));

        var models = await service.ListAsync(CancellationToken.None);

        var model = Assert.Single(models);
        Assert.Equal("openai", model.Provider);
        Assert.Equal("gpt-5-mini", model.Model);
        Assert.True(model.IsDefault);
    }

    [Fact]
    public async Task ResolveAsync_WhenModelIsNotToolCapable_RejectsSelection()
    {
        var service = CreateService(
            new ProviderModel("whisper-1", "openai", DateTimeOffset.UtcNow));

        await Assert.ThrowsAsync<ArgumentException>(() =>
            service.ResolveAsync("openai", "whisper-1", CancellationToken.None));
    }

    private static AuthoringModelCatalogService CreateService(params ProviderModel[] models) =>
        new(
            [new ModelClient(models)],
            new ProviderModelCapabilityPolicy(),
            Options.Create(new PresetAuthoringOptions
            {
                DefaultProvider = AiProviderKeys.OpenAi,
                DefaultModel = "gpt-5-mini",
                Providers = new Dictionary<string, PresetAuthoringProviderOptions>(StringComparer.OrdinalIgnoreCase)
                {
                    [AiProviderKeys.OpenAi] = new PresetAuthoringProviderOptions
                    {
                        Enabled = true,
                        ApiKey = "test-key"
                    }
                }
            }),
            NullLogger<AuthoringModelCatalogService>.Instance);

    private sealed class ModelClient(IReadOnlyList<ProviderModel> models) : IProviderModelClient
    {
        public string ProviderKey => AiProviderKeys.OpenAi;

        public Task<IReadOnlyList<ProviderModel>> ListAsync(string apiKey, CancellationToken cancellationToken) =>
            Task.FromResult(models);
    }
}
