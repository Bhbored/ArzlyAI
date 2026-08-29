using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Application.Repositories;

public interface IGenericRepository<TEntity> where TEntity : Base
{
    Task<IReadOnlyList<TEntity>> ListAsync(CancellationToken cancellationToken);
    Task<TEntity?> GetByIdAsync(Guid id, CancellationToken cancellationToken);
    Task AddAsync(TEntity entity, CancellationToken cancellationToken);
    Task UpdateAsync(TEntity entity, CancellationToken cancellationToken);
    Task DeleteAsync(TEntity entity, CancellationToken cancellationToken);
}
