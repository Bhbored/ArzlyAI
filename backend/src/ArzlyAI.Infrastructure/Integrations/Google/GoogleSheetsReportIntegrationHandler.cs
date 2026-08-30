using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleSheetsReportIntegrationHandler(
    IGoogleSheetsClient sheetsClient) : IIntegrationHandler
{
    public string Key => "google.sheets.report";

    public async Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsReportIntegrationHandler.Execute");
        return await sheetsClient.WriteReportAsync(
            GoogleIntegrationValues.Required(inputs, "spreadsheetId"),
            GoogleIntegrationValues.Required(inputs, "tabTitle"),
            inputs.TryGetValue("reportJson", out var reportJson) &&
            !string.IsNullOrWhiteSpace(reportJson)
                ? FinanceReportProjection.ToRows(reportJson)
                : GoogleIntegrationValues.Rows(inputs, "reportRowsJson"),
            GoogleIntegrationValues.Required(credentials, "google.accessToken"),
            cancellationToken);
    }
}
