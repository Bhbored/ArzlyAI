using ArzlyAI.Api.Configuration;
using ArzlyAI.Application.DTOs.Models;
using ArzlyAI.Application.Services.Models;
using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using SerilogTimings;

namespace ArzlyAI.Api.Controllers.v1;

[ApiController]
[ApiVersion(1.0)]
[EnableRateLimiting(ApiRateLimitPolicies.PresetReads)]
[Route("api/v{version:apiVersion}/providers")]
public sealed class ProvidersController(
    IProviderCatalogService service,
    ILogger<ProvidersController> logger) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<ProviderResponse>>> List(
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ProvidersController.List");
        logger.LogDebug("Handling provider catalog request");
        return Ok(await service.ListAsync(cancellationToken));
    }
}
