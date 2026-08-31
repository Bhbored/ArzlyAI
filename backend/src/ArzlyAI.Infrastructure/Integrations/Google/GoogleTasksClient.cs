using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using ArzlyAI.Application.Abstractions;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleTasksClient(
    HttpClient httpClient,
    ILogger<GoogleTasksClient> logger) : IGoogleTasksClient
{
    public async Task<string> SyncActionPlanAsync(
        string reportJson,
        string taskListTitle,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GoogleTasksClient.SyncActionPlan");
        var tasks = ActionPlanProjection.ToTasks(reportJson);
        if (tasks.Count == 0)
            throw new ArgumentException("Action plan contains no tasks to sync.");

        var listId = await EnsureTaskListAsync(taskListTitle, accessToken, cancellationToken);
        var created = 0;
        foreach (var task in tasks)
        {
            var parentId = await InsertTaskAsync(
                listId,
                task.Title,
                task.Notes,
                null,
                accessToken,
                cancellationToken);
            created++;
            foreach (var subtask in task.Subtasks)
            {
                await InsertTaskAsync(
                    listId,
                    subtask,
                    null,
                    parentId,
                    accessToken,
                    cancellationToken);
                created++;
            }
        }

        return JsonSerializer.Serialize(new { taskListId = listId, created });
    }

    private async Task<string> EnsureTaskListAsync(
        string title,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var listResponse = await SendAsync(
            HttpMethod.Get,
            "https://tasks.googleapis.com/tasks/v1/users/@me/lists",
            accessToken,
            null,
            cancellationToken);
        using var lists = await ReadJsonAsync(listResponse, cancellationToken);
        if (lists.RootElement.TryGetProperty("items", out var items) &&
            items.ValueKind == JsonValueKind.Array)
        {
            foreach (var item in items.EnumerateArray())
            {
                if (Text(item, "title").Equals(title, StringComparison.OrdinalIgnoreCase))
                    return RequiredString(item, "id");
            }
        }

        using var createResponse = await SendAsync(
            HttpMethod.Post,
            "https://tasks.googleapis.com/tasks/v1/users/@me/lists",
            accessToken,
            JsonContent.Create(new { title }),
            cancellationToken);
        using var created = await ReadJsonAsync(createResponse, cancellationToken);
        return RequiredString(created.RootElement, "id");
    }

    private async Task<string> InsertTaskAsync(
        string listId,
        string title,
        string? notes,
        string? parentId,
        string accessToken,
        CancellationToken cancellationToken)
    {
        var path = $"https://tasks.googleapis.com/tasks/v1/lists/{Uri.EscapeDataString(listId)}/tasks";
        if (!string.IsNullOrWhiteSpace(parentId))
            path += $"?parent={Uri.EscapeDataString(parentId)}";
        using var response = await SendAsync(
            HttpMethod.Post,
            path,
            accessToken,
            JsonContent.Create(new
            {
                title,
                notes = string.IsNullOrWhiteSpace(notes) ? null : notes,
                status = "needsAction"
            }),
            cancellationToken);
        using var payload = await ReadJsonAsync(response, cancellationToken);
        return RequiredString(payload.RootElement, "id");
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
            logger.LogError("Google Tasks request failed with status {StatusCode}", response.StatusCode);
            throw new HttpRequestException(
                $"Google Tasks request failed with status {(int)response.StatusCode}.",
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

    private static string RequiredString(JsonElement element, string property) =>
        element.TryGetProperty(property, out var value) && value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? throw new InvalidOperationException($"Missing '{property}'.")
            : throw new InvalidOperationException($"Missing '{property}'.");

    private static string Text(JsonElement element, string property) =>
        element.TryGetProperty(property, out var value) && value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? string.Empty
            : string.Empty;
}
