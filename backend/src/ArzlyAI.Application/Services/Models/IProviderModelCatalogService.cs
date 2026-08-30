using ArzlyAI.Application.DTOs.Models;

namespace ArzlyAI.Application.Services.Models;

public interface IProviderModelCatalogService
{
    Task<IReadOnlyList<ProviderModelResponse>> ListAsync(
        string provider,
        ListProviderModelsRequest request,
        CancellationToken cancellationToken);
}
