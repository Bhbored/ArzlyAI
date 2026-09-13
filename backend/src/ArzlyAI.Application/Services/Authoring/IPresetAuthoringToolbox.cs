namespace ArzlyAI.Application.Services.Authoring;

public interface IPresetAuthoringToolbox
{
    Task<string> ListCapabilitiesAsync(CancellationToken cancellationToken);
    Task<string> GetCapabilityDetailsAsync(string key, CancellationToken cancellationToken);
    Task<string> SaveDraftAsync(Guid sessionId, string draftJson, CancellationToken cancellationToken);
    Task<string> ValidateDraftAsync(Guid sessionId, CancellationToken cancellationToken);
    Task RecordToolResultAsync(Guid sessionId, string toolName, string resultJson, CancellationToken cancellationToken);
}
