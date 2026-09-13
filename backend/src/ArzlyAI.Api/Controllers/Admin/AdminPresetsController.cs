using ArzlyAI.Api.Configuration;
using ArzlyAI.Api.Extensions;
using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.DTOs.Admin.Presets;
using ArzlyAI.Application.Services.Authoring;
using Asp.Versioning;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace ArzlyAI.Api.Controllers.Admin;

[ApiController]
[ApiVersion(1.0)]
[Authorize(Roles = "Admin")]
[EnableRateLimiting(ApiRateLimitPolicies.AdminAuthoring)]
[Route("api/v{version:apiVersion}/admin/presets")]
public sealed class AdminPresetsController(IAdminPresetCatalogService service) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<AdminPresetSummaryResponse>>> List(CancellationToken cancellationToken) =>
        Ok(await service.ListAsync(cancellationToken));

    [HttpGet("{key}/versions/{presetVersion:int}")]
    public async Task<ActionResult<AdminPresetDetailsResponse>> Get(
        string key, int presetVersion, CancellationToken cancellationToken)
    {
        var preset = await service.GetAsync(key, presetVersion, cancellationToken);
        return preset is null ? NotFound() : Ok(preset);
    }

    [HttpPost("{key}/versions/{presetVersion:int}/draft")]
    public async Task<ActionResult<AuthoringSessionResponse>> CloneToDraft(
        string key, int presetVersion, CancellationToken cancellationToken) =>
        Ok(await service.CloneToDraftAsync(key, presetVersion, User.GetUserId(), cancellationToken));

    [HttpPost("{key}/versions/{presetVersion:int}/archive")]
    public async Task<IActionResult> Archive(
        string key, int presetVersion, CancellationToken cancellationToken)
    {
        await service.ArchiveAsync(key, presetVersion, cancellationToken);
        return NoContent();
    }
}
