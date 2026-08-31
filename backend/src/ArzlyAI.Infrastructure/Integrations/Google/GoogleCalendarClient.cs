using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using ArzlyAI.Application.Abstractions;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleCalendarClient(
    HttpClient httpClient,
    ILogger<GoogleCalendarClient> logger) : IGoogleCalendarClient
{
    public async Task<string> CreateEventsAsync(
        string reportJson,
        string calendarId,
        string asOfDate,
        string workingHoursStart,
        string workingHoursEnd,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleCalendarClient.CreateEvents");
        var events = ActionPlanProjection.ToEvents(
            reportJson,
            asOfDate,
            workingHoursStart,
            workingHoursEnd);
        if (events.Count == 0)
            throw new ArgumentException("Action plan contains no schedule blocks to sync.");

        var created = 0;
        foreach (var item in events)
        {
            var path =
                $"https://www.googleapis.com/calendar/v3/calendars/{Uri.EscapeDataString(calendarId)}/events";
            using var response = await SendAsync(
                HttpMethod.Post,
                path,
                accessToken,
                JsonContent.Create(new
                {
                    summary = item.Title,
                    description = item.Description,
                    start = new { dateTime = item.Start.ToString("o") },
                    end = new { dateTime = item.End.ToString("o") }
                }),
                cancellationToken);
            using var payload = await ReadJsonAsync(response, cancellationToken);
            if (payload.RootElement.TryGetProperty("id", out _))
                created++;
        }

        return JsonSerializer.Serialize(new { calendarId, created });
    }

    private async Task<HttpResponseMessage> SendAsync(
        HttpMethod method,
        string url,
        string accessToken,
        HttpContent? content,
        CancellationToken cancellationToken)
    {
        using var request = new HttpRequestMessage(method, url);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        if (content != null) request.Content = content;
        var response = await httpClient.SendAsync(request, cancellationToken);
        if (!response.IsSuccessStatusCode)
        {
            logger.LogError("Google Calendar request failed with status {StatusCode}", response.StatusCode);
            throw new HttpRequestException(
                $"Google Calendar request failed with status {(int)response.StatusCode}.",
                null,
                response.StatusCode);
        }
        return response;
    }

    private static async Task<JsonDocument> ReadJsonAsync(
        HttpResponseMessage response,
        CancellationToken cancellationToken) =>
        await JsonDocument.ParseAsync(
            await response.Content.ReadAsStreamAsync(cancellationToken),
            cancellationToken: cancellationToken);
}
