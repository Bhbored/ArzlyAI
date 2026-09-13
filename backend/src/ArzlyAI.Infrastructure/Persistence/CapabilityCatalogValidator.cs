using ArzlyAI.Application.Integrations;
using ArzlyAI.Application.Services.Workflows.Operations;
using Microsoft.EntityFrameworkCore;

namespace ArzlyAI.Infrastructure.Persistence;

public sealed class CapabilityCatalogValidator(
    ArzlyDbContext dbContext,
    IEnumerable<IIntegrationHandler> integrationHandlers,
    IEnumerable<IWorkflowOperation> operations)
{
    public async Task ValidateAsync(CancellationToken cancellationToken)
    {
        var catalogIntegrations = await dbContext.Integrations.Where(x => x.IsEnabled)
            .Select(x => x.Key).ToHashSetAsync(cancellationToken);
        var registeredIntegrations = integrationHandlers.Select(x => x.Key).ToHashSet(StringComparer.Ordinal);
        var catalogOperations = await dbContext.WorkflowOperations.Where(x => x.IsEnabled)
            .Select(x => x.Key).ToHashSetAsync(cancellationToken);
        var registeredOperations = operations.Select(x => x.Key).ToHashSet(StringComparer.Ordinal);
        if (!catalogIntegrations.SetEquals(registeredIntegrations))
            throw new InvalidOperationException("The integration capability catalog does not match registered handlers.");
        if (!catalogOperations.SetEquals(registeredOperations))
            throw new InvalidOperationException("The operation capability catalog does not match registered operations.");
    }
}
