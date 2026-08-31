using ArzlyAI.Application.DTOs.Connectors;
using ArzlyAI.Application.Security;

namespace ArzlyAI.Application.Services.Connectors;

public interface IGoogleResourceService
{
    Task<IReadOnlyList<GoogleSpreadsheetResponse>> ListSpreadsheetsAsync(
        CredentialEnvelope credentials,
        CancellationToken cancellationToken);

    Task<IReadOnlyList<GoogleSheetTabResponse>> ListTabsAsync(
        CredentialEnvelope credentials,
        string spreadsheetId,
        CancellationToken cancellationToken);

    Task<GoogleSheetHeadersResponse> ListHeadersAsync(
        CredentialEnvelope credentials,
        string spreadsheetId,
        string tabTitle,
        CancellationToken cancellationToken);
}
