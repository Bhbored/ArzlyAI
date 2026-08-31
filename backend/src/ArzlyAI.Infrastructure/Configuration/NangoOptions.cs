namespace ArzlyAI.Infrastructure.Configuration;

public sealed class NangoOptions
{
    public const string SectionName = "Nango";

    public string ApiKey { get; init; } = string.Empty;
    public string BaseUrl { get; init; } = "https://api.nango.dev";
    public string LinkedInIntegrationId { get; init; } = "linkedin";
    public string GoogleSheetsIntegrationId { get; init; } = "google-sheets";
    public string GmailIntegrationId { get; init; } = "gmail";
    public string GoogleTasksIntegrationId { get; init; } = "google-tasks";
    public string GoogleCalendarIntegrationId { get; init; } = "google-calendar";
}
