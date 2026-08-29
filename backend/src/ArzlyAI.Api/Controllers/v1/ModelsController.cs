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
[Route("api/v{version:apiVersion}/providers/openai/models")]
public sealed class ModelsController(
    IOpenAiModelCatalogService service,
    ILogger<ModelsController> logger) : ControllerBase
{
    [HttpPost]
    public async Task<ActionResult<IReadOnlyList<OpenAiModelResponse>>> List(
        ListOpenAiModelsRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ModelsController.List");
        logger.LogDebug("Handling OpenAI model catalog request");
        return Ok(await service.ListAsync(request, cancellationToken));
    }
}
