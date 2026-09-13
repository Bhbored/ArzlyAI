using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Domain.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public interface IPresetAuthoringAgent
{
    Task<string> ReplyAsync(
        Guid sessionId,
        IReadOnlyList<PresetAuthoringMessage> history,
        string message,
        AuthoringModelSelection model,
        CancellationToken cancellationToken);
}
