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
[EnableRateLimiting(ApiRateLimitPolicies.WorkflowExecution)]
[Route("api/v{version:apiVersion}/providers/{provider}/models")]
public sealed class ProviderModelsController(
    IProviderModelCatalogService service,
    ILogger<ProviderModelsController> logger) : ControllerBase
{
    [HttpPost]
    public async Task<ActionResult<IReadOnlyList<ProviderModelResponse>>> List(
        string provider,
        ListProviderModelsRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ProviderModelsController.List");
        logger.LogDebug("Handling {Provider} model catalog request", provider);
        return Ok(await service.ListAsync(provider, request, cancellationToken));
    }
}
