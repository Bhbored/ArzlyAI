namespace ArzlyAI.Application.Abstractions;

public interface ILinkedInPublisher
{
    Task<string> PublishTextAsync(
        string authorUrn,
        string text,
        string accessToken,
        CancellationToken cancellationToken);
}
