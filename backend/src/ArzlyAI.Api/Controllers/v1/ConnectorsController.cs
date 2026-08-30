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
    IGoogleResourceService googleResources,
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

    [HttpGet("google/resources/spreadsheets")]
    public async Task<ActionResult<IReadOnlyList<GoogleSpreadsheetResponse>>> ListGoogleSpreadsheets(
        [FromHeader(Name = "X-Device-Id")] string? deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ConnectorsController.ListGoogleSpreadsheets");
        return Ok(await googleResources.ListSpreadsheetsAsync(
            ParseDeviceId(deviceId),
            cancellationToken));
    }

    [HttpGet("google/resources/spreadsheets/{spreadsheetId}/tabs")]
    public async Task<ActionResult<IReadOnlyList<GoogleSheetTabResponse>>> ListGoogleTabs(
        string spreadsheetId,
        [FromHeader(Name = "X-Device-Id")] string? deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ConnectorsController.ListGoogleTabs");
        return Ok(await googleResources.ListTabsAsync(
            ParseDeviceId(deviceId),
            spreadsheetId,
            cancellationToken));
    }

    [HttpGet("google/resources/spreadsheets/{spreadsheetId}/tabs/{tabTitle}/headers")]
    public async Task<ActionResult<GoogleSheetHeadersResponse>> ListGoogleHeaders(
        string spreadsheetId,
        string tabTitle,
        [FromHeader(Name = "X-Device-Id")] string? deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ConnectorsController.ListGoogleHeaders");
        return Ok(await googleResources.ListHeadersAsync(
            ParseDeviceId(deviceId),
            spreadsheetId,
            tabTitle,
            cancellationToken));
    }

    private static Guid ParseDeviceId(string? value) =>
        Guid.TryParse(value, out var deviceId) && deviceId != Guid.Empty
            ? deviceId
            : throw new ArgumentException("X-Device-Id must be a non-empty UUID.");
}
