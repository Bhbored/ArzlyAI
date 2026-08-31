namespace ArzlyAI.Application.Abstractions;

public interface IGoogleCalendarClient
{
    Task<string> CreateEventsAsync(
        string reportJson,
        string calendarId,
        string asOfDate,
        string workingHoursStart,
        string workingHoursEnd,
        string accessToken,
        CancellationToken cancellationToken);
}
