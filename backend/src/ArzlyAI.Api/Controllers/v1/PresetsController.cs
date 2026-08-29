using ArzlyAI.Api.Configuration;
using ArzlyAI.Application.DTOs.Presets;
using ArzlyAI.Application.Services.Presets;
using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using SerilogTimings;

namespace ArzlyAI.Api.Controllers.v1;

[ApiController]
[ApiVersion(1.0)]
[EnableRateLimiting(ApiRateLimitPolicies.PresetReads)]
[Route("api/v{version:apiVersion}/presets")]
public sealed class PresetsController(
    IPresetService service,
    ILogger<PresetsController> logger) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<PresetSummaryResponse>>> List(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetsController.List");
        logger.LogDebug("Handling preset catalog request");
        return Ok(await service.GetAllAsync(cancellationToken));
    }

    [HttpGet("{key}")]
    public async Task<ActionResult<PresetDetailsResponse>> Get(string key, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetsController.Get");
        logger.LogDebug("Handling preset detail request for {PresetKey}", key);
        var preset = await service.GetByKeyAsync(key, cancellationToken);
        return preset is null ? NotFound() : Ok(preset);
    }
}
