using ArzlyAI.Domain.Catalog;

namespace ArzlyAI.Application.Repositories.Authoring;

public interface ICapabilityCatalogRepository
{
    Task<IReadOnlyList<IntegrationDefinition>> ListIntegrationsAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<WorkflowOperationDefinition>> ListOperationsAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<ModelDefinition>> ListModelsAsync(CancellationToken cancellationToken);
}
