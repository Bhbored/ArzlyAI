using ArzlyAI.Application.DTOs.Connectors;

namespace ArzlyAI.Application.Abstractions;

public interface IGoogleSheetsClient
{
    Task<IReadOnlyList<GoogleSpreadsheetResponse>> ListSpreadsheetsAsync(
        string accessToken,
        CancellationToken cancellationToken);

    Task<IReadOnlyList<GoogleSheetTabResponse>> ListTabsAsync(
        string spreadsheetId,
        string accessToken,
        CancellationToken cancellationToken);

    Task<IReadOnlyList<string>> ListHeadersAsync(
        string spreadsheetId,
        string tabTitle,
        string accessToken,
        CancellationToken cancellationToken);

    Task<IReadOnlyList<IReadOnlyList<string>>> ReadRangeAsync(
        string spreadsheetId,
        string range,
        int maximumRows,
        string accessToken,
        CancellationToken cancellationToken);

    Task<string> WriteRangeAsync(
        string spreadsheetId,
        string range,
        IReadOnlyList<IReadOnlyList<string>> rows,
        string accessToken,
        CancellationToken cancellationToken);

    Task<string> WriteReportAsync(
        string spreadsheetId,
        string tabTitle,
        IReadOnlyList<IReadOnlyList<string>> rows,
        string accessToken,
        CancellationToken cancellationToken);
}
