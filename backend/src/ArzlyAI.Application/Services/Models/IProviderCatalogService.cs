using ArzlyAI.Application.DTOs.Models;

namespace ArzlyAI.Application.Services.Models;

public interface IProviderCatalogService
{
    Task<IReadOnlyList<ProviderResponse>> ListAsync(CancellationToken cancellationToken);
}
