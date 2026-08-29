using ArzlyAI.Api.Configuration;
using ArzlyAI.Application.DTOs.Connectors;
using ArzlyAI.Application.Services.Connectors;
using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using SerilogTimings;

namespace ArzlyAI.Api.Controllers.v1;

[ApiController]
[ApiVersion(1.0)]
[EnableRateLimiting(ApiRateLimitPolicies.Connectors)]
[Route("api/v{version:apiVersion}/connectors")]
public sealed class ConnectorsController(
    IConnectorBroker broker,
    ILogger<ConnectorsController> logger) : ControllerBase
{
    [HttpPost("{connectorKey}/session")]
    public async Task<ActionResult<ConnectorSessionResponse>> CreateSession(
        string connectorKey,
        [FromHeader(Name = "X-Device-Id")] string? deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ConnectorsController.CreateSession");
        logger.LogDebug("Handling connector session request for {ConnectorKey}", connectorKey);
        return Ok(await broker.CreateSessionAsync(
            connectorKey,
            ParseDeviceId(deviceId),
            cancellationToken));
    }

    [HttpGet("{connectorKey}/status")]
    public async Task<ActionResult<ConnectorStatusResponse>> GetStatus(
        string connectorKey,
        [FromHeader(Name = "X-Device-Id")] string? deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ConnectorsController.GetStatus");
        return Ok(await broker.GetStatusAsync(
            connectorKey,
            ParseDeviceId(deviceId),
            cancellationToken));
    }

    [HttpGet("{connectorKey}/credentials")]
    public async Task<ActionResult<IReadOnlyDictionary<string, string>>> GetCredentials(
        string connectorKey,
        [FromHeader(Name = "X-Device-Id")] string? deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ConnectorsController.GetCredentials");
        var credentials = await broker.GetCredentialsAsync(
            connectorKey,
            ParseDeviceId(deviceId),
            cancellationToken);
        return credentials is null ? NotFound() : Ok(credentials);
    }

    [HttpDelete("{connectorKey}")]
    public async Task<IActionResult> Delete(
        string connectorKey,
        [FromHeader(Name = "X-Device-Id")] string? deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ConnectorsController.Delete");
        var deleted = await broker.DisconnectAsync(
            connectorKey,
            ParseDeviceId(deviceId),
            cancellationToken);
        return deleted ? NoContent() : NotFound();
    }

    private static Guid ParseDeviceId(string? value) =>
        Guid.TryParse(value, out var deviceId) && deviceId != Guid.Empty
            ? deviceId
            : throw new ArgumentException("X-Device-Id must be a non-empty UUID.");
}
