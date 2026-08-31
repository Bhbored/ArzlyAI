using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleTasksCreateIntegrationHandler(IGoogleTasksClient tasksClient)
    : IIntegrationHandler
{
    public string Key => "google.tasks.create";

    public Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleTasksCreateIntegrationHandler.Execute");
        return tasksClient.SyncActionPlanAsync(
            GoogleIntegrationValues.Required(inputs, "reportJson"),
            inputs.TryGetValue("taskListTitle", out var title) && !string.IsNullOrWhiteSpace(title)
                ? title
                : "ArzlyAI",
            GoogleIntegrationValues.Required(credentials, "google.accessToken"),
            cancellationToken);
    }
}
