using ArzlyAI.Application.DTOs.Admin.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public interface IPresetAuthoringService
{
    Task<IReadOnlyList<AuthoringSessionResponse>> ListAsync(CancellationToken cancellationToken);
    Task<AuthoringSessionResponse?> GetAsync(Guid sessionId, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> CreateAsync(Guid adminId, CreateAuthoringSessionRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<AuthoringModelResponse>> ListModelsAsync(CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> SetModelAsync(Guid sessionId, SetAuthoringModelRequest request, CancellationToken cancellationToken);
    Task<AuthoringTurnResponse> AddMessageAsync(Guid sessionId, AddAuthoringMessageRequest request, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> ValidateAsync(Guid sessionId, CancellationToken cancellationToken);
    Task<Guid> PublishAsync(Guid sessionId, Guid adminId, PublishPresetRequest request, CancellationToken cancellationToken);
    Task AbandonAsync(Guid sessionId, CancellationToken cancellationToken);
    Task<IReadOnlyList<CapabilityResponse>> ListCapabilitiesAsync(CancellationToken cancellationToken);
}
