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
    IGoogleResourceService googleResources,
    ILogger<ConnectorsController> logger) : ControllerBase
{
    [HttpPost("google-sheets/resources/spreadsheets/query")]
    public async Task<ActionResult<IReadOnlyList<GoogleSpreadsheetResponse>>>
        ListGoogleSpreadsheetsWithCredentials(
            [FromBody] GoogleResourceRequest request,
            CancellationToken cancellationToken)
    {
        using var operation = Operation.Time(
            "ConnectorsController.ListGoogleSpreadsheetsWithCredentials");
        logger.LogDebug("Listing Google spreadsheets from encrypted credentials");
        return Ok(await googleResources.ListSpreadsheetsAsync(
            request.Credentials,
            cancellationToken));
    }

    [HttpPost("google-sheets/resources/spreadsheets/{spreadsheetId}/tabs/query")]
    public async Task<ActionResult<IReadOnlyList<GoogleSheetTabResponse>>>
        ListGoogleTabsWithCredentials(
            string spreadsheetId,
            [FromBody] GoogleResourceRequest request,
            CancellationToken cancellationToken)
    {
        using var operation = Operation.Time(
            "ConnectorsController.ListGoogleTabsWithCredentials");
        return Ok(await googleResources.ListTabsAsync(
            request.Credentials,
            spreadsheetId,
            cancellationToken));
    }

    [HttpPost("google-sheets/resources/spreadsheets/{spreadsheetId}/tabs/{tabTitle}/headers/query")]
    public async Task<ActionResult<GoogleSheetHeadersResponse>>
        ListGoogleHeadersWithCredentials(
            string spreadsheetId,
            string tabTitle,
            [FromBody] GoogleResourceRequest request,
            CancellationToken cancellationToken)
    {
        using var operation = Operation.Time(
            "ConnectorsController.ListGoogleHeadersWithCredentials");
        return Ok(await googleResources.ListHeadersAsync(
            request.Credentials,
            spreadsheetId,
            tabTitle,
            cancellationToken));
    }
}
