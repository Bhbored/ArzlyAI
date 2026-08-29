using System.Net.Http.Headers;
using System.Net.Http.Json;
using ArzlyAI.Application.Abstractions;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.LinkedIn;

public sealed class LinkedInPublisher(
    HttpClient httpClient,
    ILogger<LinkedInPublisher> logger) : ILinkedInPublisher
{
    public async Task<string> PublishTextAsync(
        string authorUrn,
        string text,
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("LinkedInPublisher.PublishText");
        logger.LogInformation("Publishing approved text through LinkedIn");
        using var request = new HttpRequestMessage(HttpMethod.Post, "rest/posts");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        request.Headers.Add("X-Restli-Protocol-Version", "2.0.0");
        request.Headers.Add("LinkedIn-Version", "202606");
        request.Content = JsonContent.Create(new
        {
            author = authorUrn,
            commentary = text,
            visibility = "PUBLIC",
            distribution = new
            {
                feedDistribution = "MAIN_FEED",
                targetEntities = Array.Empty<object>(),
                thirdPartyDistributionChannels = Array.Empty<object>()
            },
            lifecycleState = "PUBLISHED",
            isReshareDisabledByAuthor = false
        });

        using var response = await httpClient.SendAsync(request, cancellationToken);
        if (!response.IsSuccessStatusCode)
            logger.LogError("LinkedIn publishing failed with status {StatusCode}", response.StatusCode);
        response.EnsureSuccessStatusCode();

        var postId = response.Headers.TryGetValues("x-restli-id", out var values)
            ? values.First()
            : throw new InvalidOperationException("LinkedIn did not return a post identifier.");
        logger.LogInformation("LinkedIn post was published successfully");
        return postId;
    }
}
