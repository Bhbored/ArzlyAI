using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.LinkedIn;

public sealed class LinkedInPostsIntegrationHandler(ILinkedInPublisher publisher) : IIntegrationHandler
{
    public string Key => "linkedin.posts";
    public async Task<string> ExecuteAsync(IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("LinkedInPostsIntegrationHandler.Execute");
        return await publisher.PublishTextAsync(
            Required(credentials, "linkedin.authorUrn"),
            Required(inputs, "text"),
            Required(credentials, "linkedin.accessToken"),
            cancellationToken);
    }

    private static string Required(IReadOnlyDictionary<string, string> values, string key) =>
        values.TryGetValue(key, out var value) && !string.IsNullOrWhiteSpace(value)
            ? value : throw new ArgumentException($"Required value '{key}' is missing.");
}
