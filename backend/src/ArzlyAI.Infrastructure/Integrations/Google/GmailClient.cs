using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Abstractions;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed class GmailClient(
    HttpClient httpClient,
    ILogger<GmailClient> logger) : IGmailClient
{
    public async Task<string> SendHtmlAsync(
        string recipient,
        string subject,
        string html,
        string accessToken,
        string? senderEmail,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("GmailClient.SendHtml");
        RejectHeaderInjection(recipient, nameof(recipient));
        RejectHeaderInjection(subject, nameof(subject));
        if (!string.IsNullOrWhiteSpace(senderEmail))
            RejectHeaderInjection(senderEmail, nameof(senderEmail));

        var rawMessage = BuildRawMessage(recipient, subject, html, senderEmail);
        using var request = new HttpRequestMessage(
            HttpMethod.Post,
            "https://gmail.googleapis.com/gmail/v1/users/me/messages/send");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        request.Content = JsonContent.Create(new { raw = Base64UrlEncode(rawMessage) });

        using var response = await httpClient.SendAsync(request, cancellationToken);
        if (!response.IsSuccessStatusCode)
        {
            logger.LogError("Gmail send failed with status {StatusCode}", response.StatusCode);
            throw new HttpRequestException(
                $"Gmail send failed with status {(int)response.StatusCode}.",
                null,
                response.StatusCode);
        }

        using var payload = JsonDocument.Parse(
            await response.Content.ReadAsStreamAsync(cancellationToken));
        return payload.RootElement.TryGetProperty("id", out var id)
            ? id.GetString() ?? throw new InvalidOperationException("Gmail returned an empty message id.")
            : throw new InvalidOperationException("Gmail did not return a message id.");
    }

    private static string BuildRawMessage(
        string recipient,
        string subject,
        string html,
        string? senderEmail)
    {
        var message = new StringBuilder();
        if (!string.IsNullOrWhiteSpace(senderEmail))
            message.Append("From: ").Append(senderEmail).Append("\r\n");
        message.Append("To: ").Append(recipient).Append("\r\n")
            .Append("Subject: =?UTF-8?B?")
            .Append(Convert.ToBase64String(Encoding.UTF8.GetBytes(subject)))
            .Append("?=\r\n")
            .Append("MIME-Version: 1.0\r\n")
            .Append("Content-Type: text/html; charset=UTF-8\r\n")
            .Append("Content-Transfer-Encoding: base64\r\n\r\n")
            .Append(Convert.ToBase64String(Encoding.UTF8.GetBytes(html)));
        return message.ToString();
    }

    private static string Base64UrlEncode(string value) =>
        Convert.ToBase64String(Encoding.UTF8.GetBytes(value))
            .TrimEnd('=')
            .Replace('+', '-')
            .Replace('/', '_');

    private static void RejectHeaderInjection(string value, string parameterName)
    {
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("A non-empty value is required.", parameterName);
        if (value.Contains('\r', StringComparison.Ordinal) ||
            value.Contains('\n', StringComparison.Ordinal))
            throw new ArgumentException("Email headers cannot contain line breaks.", parameterName);
    }
}
