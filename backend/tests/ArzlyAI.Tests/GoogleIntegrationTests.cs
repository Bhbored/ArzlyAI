using System.Net;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.DTOs.Connectors;
using ArzlyAI.Infrastructure.Integrations.Google;
using Microsoft.Extensions.Logging;

namespace ArzlyAI.Tests;

public sealed class GoogleIntegrationTests
{
    [Fact]
    public async Task ListSpreadsheetsAsync_WhenGoogleResponds_ReturnsMetadataOnly()
    {
        var handler = new RecordingHandler();
        handler.Enqueue(HttpStatusCode.OK,
            """{"files":[{"id":"sheet-1","name":"Expenses","modifiedTime":"2026-08-30T12:00:00Z"}]}""");
        var client = CreateSheetsClient(handler);

        var result = await client.ListSpreadsheetsAsync(
            "secret-google-token",
            CancellationToken.None);

        var spreadsheet = Assert.Single(result);
        Assert.Equal("sheet-1", spreadsheet.Id);
        Assert.Equal("Expenses", spreadsheet.Name);
        Assert.Equal("Bearer secret-google-token", Assert.Single(handler.Requests).Authorization);
        Assert.DoesNotContain("values", handler.Requests[0].Uri, StringComparison.Ordinal);
    }

    [Fact]
    public async Task ListHeadersAsync_WhenSheetContainsRows_ReturnsFirstRowOnly()
    {
        var handler = new RecordingHandler();
        handler.Enqueue(HttpStatusCode.OK,
            """{"range":"'Receipts'!1:1","values":[["Date","Merchant","Amount"]]}""");
        var client = CreateSheetsClient(handler);

        var result = await client.ListHeadersAsync(
            "sheet-1",
            "Receipts",
            "secret-google-token",
            CancellationToken.None);

        Assert.Equal(["Date", "Merchant", "Amount"], result);
        Assert.Contains(
            "values/'Receipts'!1:1",
            Uri.UnescapeDataString(Assert.Single(handler.Requests).Uri),
            StringComparison.Ordinal);
    }

    [Fact]
    public async Task ReadRangeAsync_WhenResponseExceedsLimit_ReturnsBoundedRows()
    {
        var handler = new RecordingHandler();
        handler.Enqueue(HttpStatusCode.OK, """{"values":[["1"],["2"],["3"]]}""");
        var client = CreateSheetsClient(handler);

        var result = await client.ReadRangeAsync(
            "sheet-1",
            "Receipts!A:E",
            2,
            "secret-google-token",
            CancellationToken.None);

        Assert.Equal(2, result.Count);
        Assert.Contains(
            "values/Receipts!A1:E2",
            Uri.UnescapeDataString(Assert.Single(handler.Requests).Uri),
            StringComparison.Ordinal);
    }

    [Fact]
    public async Task WriteReportAsync_WhenWriteFails_DoesNotLogTokenOrReportBody()
    {
        var handler = new RecordingHandler();
        handler.Enqueue(HttpStatusCode.OK,
            """{"sheets":[{"properties":{"sheetId":1,"title":"Report","index":0,"gridProperties":{"rowCount":10,"columnCount":10}}}]}""");
        handler.Enqueue(HttpStatusCode.OK, "{}");
        handler.Enqueue(HttpStatusCode.BadRequest, """{"error":{"message":"rejected"}}""");
        var logger = new CapturingLogger<GoogleSheetsClient>();
        var client = CreateSheetsClient(handler, logger);
        IReadOnlyList<IReadOnlyList<string>> rows =
        [
            new[] { "private-report-body" }
        ];

        await Assert.ThrowsAsync<HttpRequestException>(() => client.WriteReportAsync(
            "sheet-1",
            "Report",
            rows,
            "secret-google-token",
            CancellationToken.None));

        var messages = string.Join(' ', logger.Messages);
        Assert.DoesNotContain("private-report-body", messages, StringComparison.Ordinal);
        Assert.DoesNotContain("secret-google-token", messages, StringComparison.Ordinal);
    }

    [Fact]
    public async Task SendHtmlAsync_WhenGoogleAccepts_SendsBase64UrlMimeMessage()
    {
        var handler = new RecordingHandler();
        handler.Enqueue(HttpStatusCode.OK, """{"id":"message-123"}""");
        var logger = new CapturingLogger<GmailClient>();
        var client = new GmailClient(new HttpClient(handler), logger);

        var result = await client.SendHtmlAsync(
            "recipient@example.com",
            "Receipt report",
            "<h1>Private report</h1>",
            "secret-google-token",
            "sender@example.com",
            CancellationToken.None);

        Assert.Equal("message-123", result);
        var request = Assert.Single(handler.Requests);
        using var body = JsonDocument.Parse(request.Body!);
        var mime = DecodeBase64Url(body.RootElement.GetProperty("raw").GetString()!);
        Assert.Contains("To: recipient@example.com", mime, StringComparison.Ordinal);
        Assert.Contains("Content-Type: text/html; charset=UTF-8", mime, StringComparison.Ordinal);
        Assert.Contains(
            Convert.ToBase64String(Encoding.UTF8.GetBytes("<h1>Private report</h1>")),
            mime,
            StringComparison.Ordinal);
        Assert.DoesNotContain("secret-google-token", string.Join(' ', logger.Messages));
    }

    [Fact]
    public async Task IntegrationHandlers_WhenExecuted_UseGenericGoogleContracts()
    {
        var sheets = new GoogleSheetsStub();
        var read = new GoogleSheetsReadIntegrationHandler(sheets);
        var write = new GoogleSheetsWriteIntegrationHandler(sheets);
        var report = new GoogleSheetsReportIntegrationHandler(sheets);
        var gmail = new GmailStub();
        var send = new GmailHtmlIntegrationHandler(gmail);
        var credentials = new Dictionary<string, string>
        {
            ["google.accessToken"] = "secret-token",
            ["google.email"] = "sender@example.com"
        };

        var rowsJson = await read.ExecuteAsync(
            new Dictionary<string, string>
            {
                ["spreadsheetId"] = "sheet-1",
                ["range"] = "Receipts!A:E",
                ["maximumRows"] = "25"
            },
            credentials,
            CancellationToken.None);
        await write.ExecuteAsync(
            new Dictionary<string, string>
            {
                ["spreadsheetId"] = "sheet-1",
                ["range"] = "Output!A1",
                ["rowsJson"] = """[["one"]]"""
            },
            credentials,
            CancellationToken.None);
        await report.ExecuteAsync(
            new Dictionary<string, string>
            {
                ["spreadsheetId"] = "sheet-1",
                ["tabTitle"] = "Monthly Report",
                ["reportRowsJson"] = """[["total","100"]]"""
            },
            credentials,
            CancellationToken.None);
        await send.ExecuteAsync(
            new Dictionary<string, string>
            {
                ["recipient"] = "recipient@example.com",
                ["subject"] = "Report",
                ["html"] = "<p>Report</p>"
            },
            credentials,
            CancellationToken.None);

        Assert.Equal("""[["date","amount"]]""", rowsJson);
        Assert.Equal(25, sheets.MaximumRows);
        Assert.Equal("Output!A1", sheets.WrittenRange);
        Assert.Equal("Monthly Report", sheets.ReportTabTitle);
        Assert.Equal("sender@example.com", gmail.SenderEmail);
        Assert.Equal("secret-token", gmail.AccessToken);
    }

    [Fact]
    public async Task ReportHandlers_WhenFinanceReportProvided_ProjectSafeRowsAndHtml()
    {
        const string report = """
        {"schema":"arzly.report","version":4,"kind":"financeReport","title":"January report","summary":"USD 40 total","generatedAtUtc":"2026-01-31T00:00:00Z","blocks":[{"type":"financeSummary","title":"Spending","data":{"text":"Overview","items":[{"label":"Food","value":"USD 40","detail":"Two receipts"}],"metrics":[]}}],"sources":[]}
        """;
        var sheets = new GoogleSheetsStub();
        var gmail = new GmailStub();
        var credentials = new Dictionary<string, string>
        {
            ["google.accessToken"] = "secret-token"
        };

        await new GoogleSheetsReportIntegrationHandler(sheets).ExecuteAsync(
            new Dictionary<string, string>
            {
                ["spreadsheetId"] = "sheet-1",
                ["tabTitle"] = "January",
                ["reportJson"] = report
            }, credentials, CancellationToken.None);
        await new GmailHtmlIntegrationHandler(gmail).ExecuteAsync(
            new Dictionary<string, string>
            {
                ["recipient"] = "recipient@example.com",
                ["subject"] = "January",
                ["reportJson"] = report
            }, credentials, CancellationToken.None);

        Assert.Contains(sheets.ReportRows!, row => row.Contains("Food"));
        Assert.Contains("Receipt Intelligence", gmail.Html, StringComparison.Ordinal);
        Assert.Contains("USD 40", gmail.Html, StringComparison.Ordinal);
    }

    private static GoogleSheetsClient CreateSheetsClient(
        HttpMessageHandler handler,
        ILogger<GoogleSheetsClient>? logger = null) =>
        new(new HttpClient(handler), logger ?? new CapturingLogger<GoogleSheetsClient>());

    private static string DecodeBase64Url(string value)
    {
        var base64 = value.Replace('-', '+').Replace('_', '/');
        base64 = base64.PadRight(base64.Length + (4 - base64.Length % 4) % 4, '=');
        return Encoding.UTF8.GetString(Convert.FromBase64String(base64));
    }

    private sealed class RecordingHandler : HttpMessageHandler
    {
        private readonly Queue<HttpResponseMessage> responses = new();

        public List<RequestSnapshot> Requests { get; } = [];

        public void Enqueue(HttpStatusCode statusCode, string body) =>
            responses.Enqueue(new HttpResponseMessage(statusCode)
            {
                Content = new StringContent(body, Encoding.UTF8, "application/json")
            });

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            Requests.Add(new RequestSnapshot(
                request.Method,
                request.RequestUri!.ToString(),
                request.Headers.Authorization?.ToString(),
                request.Content is null
                    ? null
                    : await request.Content.ReadAsStringAsync(cancellationToken)));
            return responses.Dequeue();
        }
    }

    private sealed record RequestSnapshot(
        HttpMethod Method,
        string Uri,
        string? Authorization,
        string? Body);

    private sealed class GoogleSheetsStub : IGoogleSheetsClient
    {
        public int MaximumRows { get; private set; }
        public string? WrittenRange { get; private set; }
        public string? ReportTabTitle { get; private set; }
        public IReadOnlyList<IReadOnlyList<string>>? ReportRows { get; private set; }

        public Task<IReadOnlyList<GoogleSpreadsheetResponse>> ListSpreadsheetsAsync(
            string accessToken,
            CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<GoogleSpreadsheetResponse>>([]);

        public Task<IReadOnlyList<GoogleSheetTabResponse>> ListTabsAsync(
            string spreadsheetId,
            string accessToken,
            CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<GoogleSheetTabResponse>>([]);

        public Task<IReadOnlyList<string>> ListHeadersAsync(
            string spreadsheetId,
            string tabTitle,
            string accessToken,
            CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<string>>([]);

        public Task<IReadOnlyList<IReadOnlyList<string>>> ReadRangeAsync(
            string spreadsheetId,
            string range,
            int maximumRows,
            string accessToken,
            CancellationToken cancellationToken)
        {
            MaximumRows = maximumRows;
            return Task.FromResult<IReadOnlyList<IReadOnlyList<string>>>(
                [new[] { "date", "amount" }]);
        }

        public Task<string> WriteRangeAsync(
            string spreadsheetId,
            string range,
            IReadOnlyList<IReadOnlyList<string>> rows,
            string accessToken,
            CancellationToken cancellationToken)
        {
            WrittenRange = range;
            return Task.FromResult(range);
        }

        public Task<string> WriteReportAsync(
            string spreadsheetId,
            string tabTitle,
            IReadOnlyList<IReadOnlyList<string>> rows,
            string accessToken,
            CancellationToken cancellationToken)
        {
            ReportTabTitle = tabTitle;
            ReportRows = rows;
            return Task.FromResult(tabTitle);
        }
    }

    private sealed class GmailStub : IGmailClient
    {
        public string? SenderEmail { get; private set; }
        public string? AccessToken { get; private set; }
        public string? Html { get; private set; }

        public Task<string> SendHtmlAsync(
            string recipient,
            string subject,
            string html,
            string accessToken,
            string? senderEmail,
            CancellationToken cancellationToken)
        {
            SenderEmail = senderEmail;
            AccessToken = accessToken;
            Html = html;
            return Task.FromResult("message-1");
        }
    }

    private sealed class CapturingLogger<T> : ILogger<T>
    {
        public List<string> Messages { get; } = [];
        public IDisposable? BeginScope<TState>(TState state) where TState : notnull => null;
        public bool IsEnabled(LogLevel logLevel) => true;
        public void Log<TState>(
            LogLevel logLevel,
            EventId eventId,
            TState state,
            Exception? exception,
            Func<TState, Exception?, string> formatter) =>
            Messages.Add(formatter(state, exception));
    }
}
