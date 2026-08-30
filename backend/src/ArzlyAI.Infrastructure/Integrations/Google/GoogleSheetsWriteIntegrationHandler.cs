using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleSheetsWriteIntegrationHandler(
    IGoogleSheetsClient sheetsClient) : IIntegrationHandler
{
    public string Key => "google.sheets.write";

    public async Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsWriteIntegrationHandler.Execute");
        return await sheetsClient.WriteRangeAsync(
            GoogleIntegrationValues.Required(inputs, "spreadsheetId"),
            GoogleIntegrationValues.Required(inputs, "range"),
            GoogleIntegrationValues.Rows(inputs, "rowsJson"),
            GoogleIntegrationValues.Required(credentials, "google.accessToken"),
            cancellationToken);
    }
}
