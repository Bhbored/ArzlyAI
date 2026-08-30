using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.DTOs.Connectors;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Connectors;

public sealed class GoogleResourceService(
    IConnectorBroker connectorBroker,
    IGoogleSheetsClient sheetsClient) : IGoogleResourceService
{
    public async Task<IReadOnlyList<GoogleSpreadsheetResponse>> ListSpreadsheetsAsync(
        Guid deviceId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleResourceService.ListSpreadsheets");
        return await sheetsClient.ListSpreadsheetsAsync(
            await GetAccessTokenAsync(deviceId, cancellationToken),
            cancellationToken);
    }

    public async Task<IReadOnlyList<GoogleSheetTabResponse>> ListTabsAsync(
        Guid deviceId,
        string spreadsheetId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleResourceService.ListTabs");
        return await sheetsClient.ListTabsAsync(
            spreadsheetId,
            await GetAccessTokenAsync(deviceId, cancellationToken),
            cancellationToken);
    }

    public async Task<GoogleSheetHeadersResponse> ListHeadersAsync(
        Guid deviceId,
        string spreadsheetId,
        string tabTitle,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleResourceService.ListHeaders");
        var headers = await sheetsClient.ListHeadersAsync(
            spreadsheetId,
            tabTitle,
            await GetAccessTokenAsync(deviceId, cancellationToken),
            cancellationToken);
        return new GoogleSheetHeadersResponse(headers);
    }

    private async Task<string> GetAccessTokenAsync(
        Guid deviceId,
        CancellationToken cancellationToken)
    {
        var credentials = await connectorBroker.GetCredentialsAsync(
            "google",
            deviceId,
            cancellationToken);
        return credentials?.GetValueOrDefault("google.accessToken")
            ?? throw new UnauthorizedAccessException("A connected Google account is required.");
    }
}
