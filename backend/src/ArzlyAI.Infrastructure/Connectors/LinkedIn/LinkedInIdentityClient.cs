using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Serialization;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Connectors.LinkedIn;

public sealed class LinkedInIdentityClient(HttpClient httpClient) : ILinkedInIdentityClient
{
    public async Task<string> GetSubjectAsync(
        string accessToken,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("LinkedInIdentityClient.GetSubject");
        using var request = new HttpRequestMessage(HttpMethod.Get, "v2/userinfo");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        using var response = await httpClient.SendAsync(request, cancellationToken);
        response.EnsureSuccessStatusCode();
        var payload = await response.Content.ReadFromJsonAsync<UserInfoResponse>(
            cancellationToken: cancellationToken)
            ?? throw new InvalidOperationException("LinkedIn returned an empty userinfo response.");
        return string.IsNullOrWhiteSpace(payload.Subject)
            ? throw new InvalidOperationException("LinkedIn userinfo did not contain a subject.")
            : payload.Subject;
    }

    private sealed record UserInfoResponse(
        [property: JsonPropertyName("sub")] string Subject);
}
