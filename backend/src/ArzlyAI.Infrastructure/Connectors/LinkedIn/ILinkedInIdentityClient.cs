namespace ArzlyAI.Infrastructure.Connectors.LinkedIn;

public interface ILinkedInIdentityClient
{
    Task<string> GetSubjectAsync(string accessToken, CancellationToken cancellationToken);
}
