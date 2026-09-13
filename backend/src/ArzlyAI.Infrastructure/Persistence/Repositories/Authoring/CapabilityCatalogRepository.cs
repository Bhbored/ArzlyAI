using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Repositories.Authoring;

public sealed class CapabilityCatalogRepository(ArzlyDbContext dbContext) : ICapabilityCatalogRepository
{
    public async Task<IReadOnlyList<IntegrationDefinition>> ListIntegrationsAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("CapabilityCatalogRepository.ListIntegrations");
        return await dbContext.Integrations.AsNoTracking().Include(x => x.Connector)
            .OrderBy(x => x.Key).ToListAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<WorkflowOperationDefinition>> ListOperationsAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("CapabilityCatalogRepository.ListOperations");
        return await dbContext.WorkflowOperations.AsNoTracking().OrderBy(x => x.Key).ToListAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<ModelDefinition>> ListModelsAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("CapabilityCatalogRepository.ListModels");
        return await dbContext.Models.AsNoTracking().Include(x => x.Provider)
            .OrderBy(x => x.Provider.Key).ThenBy(x => x.Key).ToListAsync(cancellationToken);
    }
}
