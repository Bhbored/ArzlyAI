using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.DTOs.Connectors;
using ArzlyAI.Application.Security;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Connectors;

public sealed class GoogleResourceService(
    ICredentialEnvelopeProtector credentialsProtector,
    IGoogleSheetsClient sheetsClient) : IGoogleResourceService
{
    public async Task<IReadOnlyList<GoogleSpreadsheetResponse>> ListSpreadsheetsAsync(
        CredentialEnvelope credentials,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleResourceService.ListSpreadsheetsWithCredentials");
        return await sheetsClient.ListSpreadsheetsAsync(
            GetAccessToken(credentials),
            cancellationToken);
    }

    public async Task<IReadOnlyList<GoogleSheetTabResponse>> ListTabsAsync(
        CredentialEnvelope credentials,
        string spreadsheetId,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleResourceService.ListTabsWithCredentials");
        return await sheetsClient.ListTabsAsync(
            spreadsheetId,
            GetAccessToken(credentials),
            cancellationToken);
    }

    public async Task<GoogleSheetHeadersResponse> ListHeadersAsync(
        CredentialEnvelope credentials,
        string spreadsheetId,
        string tabTitle,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleResourceService.ListHeadersWithCredentials");
        var headers = await sheetsClient.ListHeadersAsync(
            spreadsheetId,
            tabTitle,
            GetAccessToken(credentials),
            cancellationToken);
        return new GoogleSheetHeadersResponse(headers);
    }

    private string GetAccessToken(CredentialEnvelope credentials)
    {
        var decrypted = credentialsProtector.Decrypt(credentials);
        return decrypted.GetValueOrDefault("google.accessToken")
            ?? throw new UnauthorizedAccessException(
                "A Google access token is required.");
    }
}
