using ArzlyAI.Application.DTOs.Connectors;

namespace ArzlyAI.Application.Services.Connectors;

public interface IGoogleResourceService
{
    Task<IReadOnlyList<GoogleSpreadsheetResponse>> ListSpreadsheetsAsync(
        Guid deviceId,
        CancellationToken cancellationToken);

    Task<IReadOnlyList<GoogleSheetTabResponse>> ListTabsAsync(
        Guid deviceId,
        string spreadsheetId,
        CancellationToken cancellationToken);

    Task<GoogleSheetHeadersResponse> ListHeadersAsync(
        Guid deviceId,
        string spreadsheetId,
        string tabTitle,
        CancellationToken cancellationToken);
}
