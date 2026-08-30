using ArzlyAI.Application.Constants;
using ArzlyAI.Application.DTOs.Models;
using ArzlyAI.Application.Repositories;
using ArzlyAI.Domain.Catalog;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Models;

public sealed class ProviderCatalogService(
    IGenericRepository<ProviderDefinition> providers) : IProviderCatalogService
{
    public async Task<IReadOnlyList<ProviderResponse>> ListAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ProviderCatalogService.List");
        var rows = await providers.ListAsync(cancellationToken);
        return rows
            .Where(provider => AiProviderKeys.All.Contains(provider.Key, StringComparer.OrdinalIgnoreCase))
            .OrderBy(provider => provider.Key, StringComparer.OrdinalIgnoreCase)
            .Select(provider => new ProviderResponse(provider.Key, provider.DisplayName))
            .ToList();
    }
}
