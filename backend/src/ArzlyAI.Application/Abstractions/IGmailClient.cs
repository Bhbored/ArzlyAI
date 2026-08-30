namespace ArzlyAI.Application.Abstractions;

public interface IGmailClient
{
    Task<string> SendHtmlAsync(
        string recipient,
        string subject,
        string html,
        string accessToken,
        string? senderEmail,
        CancellationToken cancellationToken);
}
