using System.Net;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GoogleApiException : HttpRequestException
{
    public GoogleApiException(
        string apiName,
        HttpStatusCode statusCode,
        string? reason,
        string? providerMessage)
        : base(CreateMessage(apiName, statusCode, reason), null, statusCode)
    {
        ApiName = apiName;
        Reason = reason;
        ProviderMessage = providerMessage;
    }

    public string ApiName { get; }

    public string? Reason { get; }

    public string? ProviderMessage { get; }

    private static string CreateMessage(
        string apiName,
        HttpStatusCode statusCode,
        string? reason)
    {
        if (statusCode == HttpStatusCode.Forbidden &&
            IsReason(reason, "SERVICE_DISABLED", "accessNotConfigured"))
        {
            return $"{apiName} is disabled for the OAuth client's Google Cloud project. " +
                   "Enable the API and try again.";
        }

        if (statusCode == HttpStatusCode.Forbidden &&
            IsReason(reason, "ACCESS_TOKEN_SCOPE_INSUFFICIENT", "insufficientPermissions"))
        {
            return $"The Google access token is missing permission for {apiName}. " +
                   "Reconnect the Google Sheets connector and grant the requested permissions.";
        }

        if (statusCode == HttpStatusCode.Forbidden)
        {
            return $"{apiName} rejected the request. Verify that the API is enabled, " +
                   "the required OAuth scopes were granted, and the account can access the file.";
        }

        return $"{apiName} request failed with status {(int)statusCode}.";
    }

    private static bool IsReason(string? actual, params string[] expected) =>
        actual is not null && expected.Any(value =>
            value.Equals(actual, StringComparison.OrdinalIgnoreCase));
}
