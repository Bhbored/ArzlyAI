using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Domain.Authoring;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public interface IPresetAuthoringProviderAgent
{
    string ProviderKey { get; }

    Task<string> ReplyAsync(
        Guid sessionId,
        IReadOnlyList<PresetAuthoringMessage> history,
        string message,
        AuthoringModelSelection model,
        string apiKey,
        int timeoutSeconds,
        CancellationToken cancellationToken);
}
