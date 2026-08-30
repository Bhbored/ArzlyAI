using ArzlyAI.Application.Models.Providers;

namespace ArzlyAI.Application.Services.Models;

public interface IProviderModelClient
{
    string ProviderKey { get; }

    Task<IReadOnlyList<ProviderModel>> ListAsync(
        string apiKey,
        CancellationToken cancellationToken);
}
