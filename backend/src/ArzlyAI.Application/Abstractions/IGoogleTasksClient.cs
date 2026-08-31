namespace ArzlyAI.Application.Abstractions;

public interface IGoogleTasksClient
{
    Task<string> SyncActionPlanAsync(
        string reportJson,
        string taskListTitle,
        string accessToken,
        CancellationToken cancellationToken);
}
