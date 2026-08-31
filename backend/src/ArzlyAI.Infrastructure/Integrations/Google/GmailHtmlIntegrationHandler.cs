using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GmailHtmlIntegrationHandler(IGmailClient gmailClient) : IIntegrationHandler
{
    public string Key => "google.gmail.send-html";

    public async Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GmailHtmlIntegrationHandler.Execute");
        return await gmailClient.SendHtmlAsync(
            GoogleIntegrationValues.Required(inputs, "recipient"),
            GoogleIntegrationValues.Required(inputs, "subject"),
            inputs.TryGetValue("reportJson", out var reportJson) &&
            !string.IsNullOrWhiteSpace(reportJson)
                ? ActionPlanProjection.ToHtml(reportJson)
                : GoogleIntegrationValues.Required(inputs, "html"),
            GoogleIntegrationValues.Required(credentials, "google.accessToken"),
            credentials.GetValueOrDefault("google.email"),
            cancellationToken);
    }
}
