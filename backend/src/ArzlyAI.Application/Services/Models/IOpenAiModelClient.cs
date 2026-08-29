using ArzlyAI.Application.Models.Providers;

namespace ArzlyAI.Application.Services.Models;

public interface IOpenAiModelClient
{
    Task<IReadOnlyList<ProviderModel>> ListAsync(
        string apiKey,
        CancellationToken cancellationToken);
}
