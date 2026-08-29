using System.Threading.RateLimiting;
using Microsoft.AspNetCore.SignalR;
using SerilogTimings;

namespace ArzlyAI.Api.Hubs;

public sealed class WorkflowHubRateLimitFilter(
    PartitionedRateLimiter<string> rateLimiter,
    ILogger<WorkflowHubRateLimitFilter> logger) : IHubFilter
{
    public async ValueTask<object?> InvokeMethodAsync(
        HubInvocationContext invocationContext,
        Func<HubInvocationContext, ValueTask<object?>> next)
    {
        using var operation = Operation.Time("WorkflowHubRateLimitFilter.InvokeMethod");
        var address = invocationContext.Context.GetHttpContext()?.Connection.RemoteIpAddress;
        var partitionKey = address is null ? "ip:unknown" : $"ip:{address.MapToIPv6()}";
        using var lease = await rateLimiter.AcquireAsync(partitionKey, permitCount: 1,
            invocationContext.Context.ConnectionAborted);

        if (!lease.IsAcquired)
        {
            logger.LogWarning("SignalR invocation rate limit exceeded for {PartitionKey}", partitionKey);
            throw new HubException("Too many hub invocations. Try again shortly.");
        }

        return await next(invocationContext);
    }
}
