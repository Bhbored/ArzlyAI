using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleCalendarCreateEventsIntegrationHandler(
    IGoogleCalendarClient calendarClient) : IIntegrationHandler
{
    public string Key => "google.calendar.create-events";

    public Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleCalendarCreateEventsIntegrationHandler.Execute");
        return calendarClient.CreateEventsAsync(
            GoogleIntegrationValues.Required(inputs, "reportJson"),
            inputs.TryGetValue("calendarId", out var calendarId) &&
            !string.IsNullOrWhiteSpace(calendarId)
                ? calendarId
                : "primary",
            GoogleIntegrationValues.Required(inputs, "asOfDate"),
            GoogleIntegrationValues.Required(inputs, "workingHoursStart"),
            GoogleIntegrationValues.Required(inputs, "workingHoursEnd"),
            GoogleIntegrationValues.Required(credentials, "google.accessToken"),
            cancellationToken);
    }
}
