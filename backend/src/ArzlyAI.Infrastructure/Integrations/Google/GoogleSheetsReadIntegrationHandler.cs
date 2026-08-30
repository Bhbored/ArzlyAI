using System.Text.Json;
using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleSheetsReadIntegrationHandler(
    IGoogleSheetsClient sheetsClient) : IIntegrationHandler
{
    public string Key => "google.sheets.read";

    public async Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsReadIntegrationHandler.Execute");
        var rows = await sheetsClient.ReadRangeAsync(
            GoogleIntegrationValues.Required(inputs, "spreadsheetId"),
            GoogleIntegrationValues.Required(inputs, "range"),
            GoogleIntegrationValues.MaximumRows(inputs),
            GoogleIntegrationValues.Required(credentials, "google.accessToken"),
            cancellationToken);
        return JsonSerializer.Serialize(rows);
    }
}
