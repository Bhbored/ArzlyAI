using ArzlyAI.Api.Configuration;
using ArzlyAI.Api.Extensions;
using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Services.Authoring;
using Asp.Versioning;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using SerilogTimings;

namespace ArzlyAI.Api.Controllers.Admin;

[ApiController]
[ApiVersion(1.0)]
[Authorize(Roles = "Admin")]
[EnableRateLimiting(ApiRateLimitPolicies.AdminAuthoring)]
[Route("api/v{version:apiVersion}/admin/authoring")]
public sealed class PresetAuthoringController(IPresetAuthoringService service) : ControllerBase
{
    [HttpGet("sessions")]
    public async Task<ActionResult<IReadOnlyList<AuthoringSessionResponse>>> List(CancellationToken cancellationToken) =>
        Ok(await service.ListAsync(cancellationToken));

    [HttpGet("sessions/{sessionId:guid}")]
    public async Task<ActionResult<AuthoringSessionResponse>> Get(Guid sessionId, CancellationToken cancellationToken)
    {
        var session = await service.GetAsync(sessionId, cancellationToken);
        return session is null ? NotFound() : Ok(session);
    }

    [HttpGet("session-summaries")]
    public async Task<ActionResult<IReadOnlyList<AuthoringSessionSummaryResponse>>> Summaries(CancellationToken cancellationToken) =>
        Ok(await service.ListSummariesAsync(cancellationToken));

    [HttpGet("runtime-models")]
    public async Task<ActionResult<IReadOnlyList<AuthoringRuntimeModelResponse>>> RuntimeModels(CancellationToken cancellationToken) =>
        Ok(await service.ListRuntimeModelsAsync(cancellationToken));

    [HttpPost("sessions")]
    public async Task<ActionResult<AuthoringSessionResponse>> Create(
        CreateAuthoringSessionRequest request, CancellationToken cancellationToken)
    {
        var result = await service.CreateAsync(User.GetUserId(), request, cancellationToken);
        return CreatedAtAction(nameof(Get), new { sessionId = result.Id, version = "1" }, result);
    }

    [HttpGet("assistant-models")]
    public async Task<ActionResult<IReadOnlyList<AuthoringModelResponse>>> ListAssistantModels(
        CancellationToken cancellationToken) =>
        Ok(await service.ListModelsAsync(cancellationToken));

    [HttpGet("assistant-providers")]
    public async Task<ActionResult<IReadOnlyList<AuthoringProviderResponse>>> ListAssistantProviders(
        CancellationToken cancellationToken) =>
        Ok(await service.ListProvidersAsync(cancellationToken));

    [HttpPut("sessions/{sessionId:guid}/assistant-model")]
    public async Task<ActionResult<AuthoringSessionResponse>> SetAssistantModel(
        Guid sessionId,
        SetAuthoringModelRequest request,
        CancellationToken cancellationToken) =>
        Ok(await service.SetModelAsync(sessionId, request, cancellationToken));

    [HttpPost("sessions/{sessionId:guid}/messages")]
    public async Task<ActionResult<AuthoringTurnResponse>> AddMessage(
        Guid sessionId, AddAuthoringMessageRequest request)
    {
        using var operation = Operation.Time("PresetAuthoringController.AddMessage");
        using var timeout = new CancellationTokenSource(TimeSpan.FromMinutes(5));
        var outcome = await service.AddMessageAsync(sessionId, request, timeout.Token);
        return outcome.IsConflict
            ? Conflict(new
            {
                success = false,
                message = "The authoring session changed while it was being edited. Reload the session and retry.",
                correlationId = HttpContext.TraceIdentifier
            })
            : Ok(outcome.Response);
    }

    [HttpPost("sessions/{sessionId:guid}/validate")]
    public async Task<ActionResult<AuthoringSessionResponse>> Validate(
        Guid sessionId, CancellationToken cancellationToken) =>
        Ok(await service.ValidateAsync(sessionId, cancellationToken));

    [HttpPut("sessions/{sessionId:guid}/draft")]
    public async Task<ActionResult<AuthoringSessionResponse>> SaveDraft(
        Guid sessionId, SaveAuthoringDraftRequest request, CancellationToken cancellationToken) =>
        Ok(await service.SaveDraftAsync(sessionId, request, cancellationToken));

    [HttpPost("sessions/{sessionId:guid}/preview")]
    public async Task<ActionResult<AuthoringPreviewResponse>> Preview(
        Guid sessionId, PreviewAuthoringDraftRequest request, CancellationToken cancellationToken) =>
        Ok(await service.PreviewAsync(sessionId, request, cancellationToken));

    [HttpPost("sessions/{sessionId:guid}/publish")]
    public async Task<IActionResult> Publish(
        Guid sessionId, PublishPresetRequest request, CancellationToken cancellationToken)
    {
        var presetId = await service.PublishAsync(sessionId, User.GetUserId(), request, cancellationToken);
        return Ok(new { presetId });
    }

    [HttpPost("sessions/{sessionId:guid}/abandon")]
    public async Task<ActionResult<AuthoringSessionResponse>> Abandon(
        Guid sessionId,
        CancellationToken cancellationToken) =>
        Ok(await service.AbandonAsync(sessionId, cancellationToken));

    [HttpPost("sessions/{sessionId:guid}/restore")]
    public async Task<ActionResult<AuthoringSessionResponse>> Restore(
        Guid sessionId,
        CancellationToken cancellationToken) =>
        Ok(await service.RestoreAsync(sessionId, cancellationToken));

    [HttpDelete("sessions/{sessionId:guid}/permanent")]
    public async Task<IActionResult> DeletePermanently(
        Guid sessionId,
        CancellationToken cancellationToken)
    {
        await service.DeleteAsync(sessionId, cancellationToken);
        return NoContent();
    }

    [HttpDelete("sessions/{sessionId:guid}")]
    public async Task<IActionResult> AbandonLegacy(
        Guid sessionId,
        CancellationToken cancellationToken)
    {
        await service.AbandonAsync(sessionId, cancellationToken);
        return NoContent();
    }

    [HttpGet("capabilities")]
    public async Task<ActionResult<IReadOnlyList<CapabilityResponse>>> Capabilities(CancellationToken cancellationToken) =>
        Ok(await service.ListCapabilitiesAsync(cancellationToken));
}
