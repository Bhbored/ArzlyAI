using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.RegularExpressions;
using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.DTOs.Connectors;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleSheetsClient(
    HttpClient httpClient,
    ILogger<GoogleSheetsClient> logger) : IGoogleSheetsClient
{
    public async Task<IReadOnlyList<GoogleSpreadsheetResponse>> ListSpreadsheetsAsync(
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsClient.ListSpreadsheets");
        const string query = "mimeType='application/vnd.google-apps.spreadsheet' and trashed=false";
        var path = "https://www.googleapis.com/drive/v3/files" +
                   $"?q={Uri.EscapeDataString(query)}" +
                   "&fields=files(id,name,modifiedTime)" +
                   "&orderBy=modifiedTime%20desc&pageSize=100";
        using var response = await SendAsync(HttpMethod.Get, path, accessToken, null, cancellationToken);
        using var payload = await ReadJsonAsync(response, cancellationToken);
        return payload.RootElement.GetProperty("files")
            .EnumerateArray()
            .Select(file => new GoogleSpreadsheetResponse(
                RequiredString(file, "id"),
                RequiredString(file, "name"),
                OptionalDateTimeOffset(file, "modifiedTime")))
            .ToList();
    }

    public async Task<IReadOnlyList<GoogleSheetTabResponse>> ListTabsAsync(
        string spreadsheetId,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsClient.ListTabs");
        var path = $"https://sheets.googleapis.com/v4/spreadsheets/{Encode(spreadsheetId)}" +
                   "?fields=sheets(properties(sheetId,title,index,gridProperties(rowCount,columnCount)))";
        using var response = await SendAsync(HttpMethod.Get, path, accessToken, null, cancellationToken);
        using var payload = await ReadJsonAsync(response, cancellationToken);
        return payload.RootElement.GetProperty("sheets")
            .EnumerateArray()
            .Select(sheet =>
            {
                var properties = sheet.GetProperty("properties");
                var grid = properties.GetProperty("gridProperties");
                return new GoogleSheetTabResponse(
                    properties.GetProperty("sheetId").GetInt32(),
                    RequiredString(properties, "title"),
                    properties.GetProperty("index").GetInt32(),
                    grid.GetProperty("rowCount").GetInt32(),
                    grid.GetProperty("columnCount").GetInt32());
            })
            .OrderBy(tab => tab.Index)
            .ToList();
    }

    public async Task<IReadOnlyList<string>> ListHeadersAsync(
        string spreadsheetId,
        string tabTitle,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsClient.ListHeaders");
        var rows = await ReadValuesAsync(
            spreadsheetId,
            $"{QuoteTab(tabTitle)}!1:1",
            accessToken,
            cancellationToken);
        return rows.FirstOrDefault() ?? [];
    }

    public async Task<IReadOnlyList<IReadOnlyList<string>>> ReadRangeAsync(
        string spreadsheetId,
        string range,
        int maximumRows,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsClient.ReadRange");
        if (maximumRows is < 1 or > 1000)
            throw new ArgumentOutOfRangeException(
                nameof(maximumRows),
                "Maximum rows must be between 1 and 1000.");
        var rows = await ReadValuesAsync(
            spreadsheetId,
            BoundRange(range, maximumRows),
            accessToken,
            cancellationToken);
        return rows.Take(maximumRows).ToList();
    }

    public async Task<string> WriteRangeAsync(
        string spreadsheetId,
        string range,
        IReadOnlyList<IReadOnlyList<string>> rows,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsClient.WriteRange");
        if (rows.Count == 0)
            throw new ArgumentException("At least one row is required.", nameof(rows));
        var path = $"https://sheets.googleapis.com/v4/spreadsheets/{Encode(spreadsheetId)}" +
                   $"/values/{Encode(range)}?valueInputOption=USER_ENTERED";
        using var response = await SendAsync(
            HttpMethod.Put,
            path,
            accessToken,
            JsonContent.Create(new { majorDimension = "ROWS", values = rows }),
            cancellationToken);
        using var payload = await ReadJsonAsync(response, cancellationToken);
        return RequiredString(payload.RootElement, "updatedRange");
    }

    public async Task<string> WriteReportAsync(
        string spreadsheetId,
        string tabTitle,
        IReadOnlyList<IReadOnlyList<string>> rows,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleSheetsClient.WriteReport");
        if (rows.Count == 0)
            throw new ArgumentException("At least one report row is required.", nameof(rows));
        var tabs = await ListTabsAsync(spreadsheetId, accessToken, cancellationToken);
        if (tabs.All(tab => !tab.Title.Equals(tabTitle, StringComparison.Ordinal)))
            await AddTabAsync(spreadsheetId, tabTitle, accessToken, cancellationToken);

        var range = $"{QuoteTab(tabTitle)}!A:ZZZ";
        var clearPath = $"https://sheets.googleapis.com/v4/spreadsheets/{Encode(spreadsheetId)}" +
                        $"/values/{Encode(range)}:clear";
        using (var clearResponse = await SendAsync(
                   HttpMethod.Post,
                   clearPath,
                   accessToken,
                   JsonContent.Create(new { }),
                   cancellationToken))
        {
        }

        await WriteRangeAsync(
            spreadsheetId,
            $"{QuoteTab(tabTitle)}!A1",
            rows,
            accessToken,
            cancellationToken);
        return tabTitle;
    }

    private async Task<IReadOnlyList<IReadOnlyList<string>>> ReadValuesAsync(
        string spreadsheetId,
        string range,
        string accessToken,
        CancellationToken cancellationToken)
    {
        var path = $"https://sheets.googleapis.com/v4/spreadsheets/{Encode(spreadsheetId)}" +
                   $"/values/{Encode(range)}?majorDimension=ROWS";
        using var response = await SendAsync(HttpMethod.Get, path, accessToken, null, cancellationToken);
        using var payload = await ReadJsonAsync(response, cancellationToken);
        if (!payload.RootElement.TryGetProperty("values", out var values))
            return [];
        return values.EnumerateArray()
            .Select(row => (IReadOnlyList<string>)row.EnumerateArray()
                .Select(value => value.ValueKind == JsonValueKind.String
                    ? value.GetString() ?? string.Empty
                    : value.ToString())
                .ToList())
            .ToList();
    }

    private async Task AddTabAsync(
        string spreadsheetId,
        string tabTitle,
        string accessToken,
        CancellationToken cancellationToken)
    {
        var path = $"https://sheets.googleapis.com/v4/spreadsheets/{Encode(spreadsheetId)}:batchUpdate";
        using var response = await SendAsync(
            HttpMethod.Post,
            path,
            accessToken,
            JsonContent.Create(new
            {
                requests = new[]
                {
                    new { addSheet = new { properties = new { title = tabTitle } } }
                }
            }),
            cancellationToken);
    }

    private async Task<HttpResponseMessage> SendAsync(
        HttpMethod method,
        string path,
        string accessToken,
        HttpContent? content,
        CancellationToken cancellationToken)
    {
        using var request = new HttpRequestMessage(method, path);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        request.Content = content;
        var response = await httpClient.SendAsync(request, cancellationToken);
        if (response.IsSuccessStatusCode) return response;
        logger.LogError(
            "Google Sheets request failed with status {StatusCode} for {Method}",
            response.StatusCode,
            method);
        response.Dispose();
        throw new HttpRequestException(
            $"Google Sheets request failed with status {(int)response.StatusCode}.",
            null,
            response.StatusCode);
    }

    private static async Task<JsonDocument> ReadJsonAsync(
        HttpResponseMessage response,
        CancellationToken cancellationToken) =>
        JsonDocument.Parse(await response.Content.ReadAsStreamAsync(cancellationToken));

    private static string QuoteTab(string tabTitle) =>
        $"'{tabTitle.Replace("'", "''", StringComparison.Ordinal)}'";

    private static string BoundRange(string range, int maximumRows)
    {
        var separator = range.LastIndexOf('!');
        var prefix = separator >= 0 ? range[..(separator + 1)] : string.Empty;
        var coordinates = separator >= 0 ? range[(separator + 1)..] : range;
        var match = Regex.Match(
            coordinates,
            @"^(?<startColumn>[A-Za-z]+)(?<startRow>\d*):(?<endColumn>[A-Za-z]+)(?<endRow>\d*)$",
            RegexOptions.CultureInvariant);
        if (!match.Success)
            throw new ArgumentException(
                "Range must be an A1 column range such as Receipts!A:E or Receipts!A2:E.",
                nameof(range));

        var startRow = match.Groups["startRow"].Success &&
                       !string.IsNullOrEmpty(match.Groups["startRow"].Value)
            ? long.Parse(match.Groups["startRow"].Value)
            : 1L;
        if (startRow < 1 || startRow > int.MaxValue - maximumRows)
            throw new ArgumentException("Range contains an invalid start row.", nameof(range));
        var maximumEndRow = startRow + maximumRows - 1;
        var requestedEndRow = match.Groups["endRow"].Success &&
                              !string.IsNullOrEmpty(match.Groups["endRow"].Value)
            ? long.Parse(match.Groups["endRow"].Value)
            : maximumEndRow;
        var endRow = Math.Min(requestedEndRow, maximumEndRow);
        if (endRow < startRow)
            throw new ArgumentException("Range end row must not precede its start row.", nameof(range));

        return $"{prefix}{match.Groups["startColumn"].Value}{startRow}:" +
               $"{match.Groups["endColumn"].Value}{endRow}";
    }

    private static string Encode(string value) => Uri.EscapeDataString(value);

    private static string RequiredString(JsonElement element, string property) =>
        element.TryGetProperty(property, out var value) && value.ValueKind == JsonValueKind.String
            ? value.GetString()!
            : throw new InvalidOperationException(
                $"Google response did not contain '{property}'.");

    private static DateTimeOffset? OptionalDateTimeOffset(JsonElement element, string property) =>
        element.TryGetProperty(property, out var value) &&
        value.ValueKind == JsonValueKind.String &&
        DateTimeOffset.TryParse(value.GetString(), out var parsed)
            ? parsed
            : null;
}
