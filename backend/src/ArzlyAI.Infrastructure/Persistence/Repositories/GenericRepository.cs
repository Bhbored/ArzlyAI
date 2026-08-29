using ArzlyAI.Application.Repositories;
using ArzlyAI.Domain.Entities.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Repositories;

public class GenericRepository<TEntity>(
    ArzlyDbContext dbContext,
    ILogger<GenericRepository<TEntity>> logger) : IGenericRepository<TEntity>
    where TEntity : Base
{
    protected ArzlyDbContext DbContext { get; } = dbContext;
    protected DbSet<TEntity> Entities { get; } = dbContext.Set<TEntity>();

    public virtual async Task<IReadOnlyList<TEntity>> ListAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GenericRepository.List<{EntityType}>", typeof(TEntity).Name);
        logger.LogDebug("Listing {EntityType} entities", typeof(TEntity).Name);
        return await Entities.AsNoTracking().ToListAsync(cancellationToken);
    }

    public virtual async Task<TEntity?> GetByIdAsync(Guid id, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GenericRepository.GetById<{EntityType}>", typeof(TEntity).Name);
        logger.LogDebug("Loading {EntityType} {EntityId}", typeof(TEntity).Name, id);
        return await Entities.FindAsync([id], cancellationToken);
    }

    public virtual async Task AddAsync(TEntity entity, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GenericRepository.Add<{EntityType}>", typeof(TEntity).Name);
        await Entities.AddAsync(entity, cancellationToken);
        await DbContext.SaveChangesAsync(cancellationToken);
        logger.LogInformation("Added {EntityType} {EntityId}", typeof(TEntity).Name, entity.Id);
    }

    public virtual async Task UpdateAsync(TEntity entity, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GenericRepository.Update<{EntityType}>", typeof(TEntity).Name);
        Entities.Update(entity);
        await DbContext.SaveChangesAsync(cancellationToken);
        logger.LogInformation("Updated {EntityType} {EntityId}", typeof(TEntity).Name, entity.Id);
    }

    public virtual async Task DeleteAsync(TEntity entity, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GenericRepository.Delete<{EntityType}>", typeof(TEntity).Name);
        Entities.Remove(entity);
        await DbContext.SaveChangesAsync(cancellationToken);
        logger.LogInformation("Deleted {EntityType} {EntityId}", typeof(TEntity).Name, entity.Id);
    }
}
