using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public interface IPresetAuthoringService
{
    Task<IReadOnlyList<AuthoringSessionResponse>> ListAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<AuthoringSessionSummaryResponse>> ListSummariesAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<AuthoringRuntimeModelResponse>> ListRuntimeModelsAsync(CancellationToken cancellationToken);
    Task<AuthoringSessionResponse?> GetAsync(Guid sessionId, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> CreateAsync(Guid adminId, CreateAuthoringSessionRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<AuthoringProviderResponse>> ListProvidersAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<AuthoringModelResponse>> ListModelsAsync(CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> SetModelAsync(Guid sessionId, SetAuthoringModelRequest request, CancellationToken cancellationToken);
    Task<AuthoringTurnOutcome> AddMessageAsync(Guid sessionId, AddAuthoringMessageRequest request, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> ValidateAsync(Guid sessionId, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> SaveDraftAsync(Guid sessionId, SaveAuthoringDraftRequest request, CancellationToken cancellationToken);
    Task<AuthoringPreviewResponse> PreviewAsync(Guid sessionId, PreviewAuthoringDraftRequest request, CancellationToken cancellationToken);
    Task<Guid> PublishAsync(Guid sessionId, Guid adminId, PublishPresetRequest request, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> AbandonAsync(Guid sessionId, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> RestoreAsync(Guid sessionId, CancellationToken cancellationToken);
    Task DeleteAsync(Guid sessionId, CancellationToken cancellationToken);
    Task<IReadOnlyList<CapabilityResponse>> ListCapabilitiesAsync(CancellationToken cancellationToken);
}
