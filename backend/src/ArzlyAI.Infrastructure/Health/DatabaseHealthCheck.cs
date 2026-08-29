using ArzlyAI.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Health;

public sealed class DatabaseHealthCheck(
    ArzlyDbContext dbContext,
    ILogger<DatabaseHealthCheck> logger) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        using var operation = Operation.Time("DatabaseHealthCheck.CheckHealth");

        try
        {
            if (await dbContext.Database.CanConnectAsync(cancellationToken))
            {
                logger.LogDebug("PostgreSQL database health check succeeded");
                return HealthCheckResult.Healthy("Database connection succeeded");
            }

            logger.LogWarning("PostgreSQL database health check could not connect");
            return HealthCheckResult.Unhealthy("Database connection failed");
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "PostgreSQL database readiness check failed");
            return HealthCheckResult.Unhealthy("Database readiness check failed", exception);
        }
    }
}
