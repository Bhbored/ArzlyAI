using ArzlyAI.Api.Configuration;
using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Services.Workflows;
using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using SerilogTimings;
namespace ArzlyAI.Api.Controllers.v1;

[ApiController]
[ApiVersion(1.0)]
[Route("api/v{version:apiVersion}/workflows")]
public sealed class WorkflowsController(
    IWorkflowExecutionService workflows,
    ILogger<WorkflowsController> logger) : ControllerBase
{
    [HttpPost("runs")]
    [EnableRateLimiting(ApiRateLimitPolicies.WorkflowExecution)]
    public async Task<ActionResult<WorkflowRunResponse>> Start(StartWorkflowRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowsController.Start");
        logger.LogInformation("Received workflow start request for preset {PresetKey}", request.PresetKey);
        return Ok(await workflows.StartAsync(request, cancellationToken));
    }

    [HttpGet("runs/{runId:guid}")]
    [EnableRateLimiting(ApiRateLimitPolicies.WorkflowExecution)]
    public async Task<ActionResult<WorkflowRunResponse>> Get(Guid runId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowsController.Get");
        logger.LogDebug("Reading workflow run {RunId}", runId);
        var run = await workflows.GetAsync(runId, cancellationToken);
        return run is null ? NotFound() : Ok(run);
    }

    [HttpPost("runs/{runId:guid}/approval")]
    [EnableRateLimiting(ApiRateLimitPolicies.WorkflowExecution)]
    public async Task<ActionResult<WorkflowRunResponse>> SubmitApproval(
        Guid runId, SubmitApprovalRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowsController.SubmitApproval");
        logger.LogInformation("Received {Decision} decision for workflow run {RunId}", request.Decision, runId);
        return Ok(await workflows.SubmitApprovalAsync(runId, request, cancellationToken));
    }
}
