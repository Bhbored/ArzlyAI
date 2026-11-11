using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;
using SerilogTimings;
using Microsoft.Extensions.Logging;

namespace ArzlyAI.Application.Services.Authoring;

public sealed class PresetAuthoringService(
    IPresetAuthoringRepository repository,
    ICapabilityCatalogRepository capabilities,
    IPresetAuthoringAgent agent,
    IAuthoringModelCatalogService models,
    IPresetDraftValidator validator,
    IPresetPublisher publisher,
    IAuthoringRealtimeNotifier realtime,
    ILogger<PresetAuthoringService>? logger = null) : IPresetAuthoringService
{
    public async Task<IReadOnlyList<AuthoringSessionResponse>> ListAsync(CancellationToken cancellationToken) =>
        (await repository.ListAsync(cancellationToken)).Select(ToResponse).ToList();

    public async Task<IReadOnlyList<AuthoringSessionSummaryResponse>> ListSummariesAsync(CancellationToken cancellationToken) =>
        (await repository.ListSummariesAsync(cancellationToken)).Select(session => new AuthoringSessionSummaryResponse(
            session.Id, session.Title, session.Status.ToString(), session.Revision,
            new AuthoringModelSelectionResponse(session.AssistantProvider ?? "unconfigured", session.AssistantModel ?? "unconfigured"),
            session.UpdatedAtUtc)).ToList();

    public async Task<IReadOnlyList<AuthoringRuntimeModelResponse>> ListRuntimeModelsAsync(CancellationToken cancellationToken) =>
        (await capabilities.ListModelsAsync(cancellationToken)).Select(model =>
            new AuthoringRuntimeModelResponse(model.Provider.Key, model.Key, model.DisplayName)).ToList();

    public async Task<AuthoringSessionResponse?> GetAsync(Guid sessionId, CancellationToken cancellationToken)
    {
        var session = await repository.GetAsync(sessionId, cancellationToken);
        if (session is not null) await RecoverExpiredTurnAsync(session, cancellationToken);
        return session is null ? null : ToResponse(session);
    }

    public async Task<AuthoringSessionResponse> CreateAsync(
        Guid adminId, CreateAuthoringSessionRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringService.Create");
        var requestedModel = string.IsNullOrWhiteSpace(request.Provider) || string.IsNullOrWhiteSpace(request.Model)
            ? models.GetDefaultSelection()
            : new AuthoringModelSelection(request.Provider, request.Model);
        var selectedModel = request.UseVisualBuilder ? requestedModel : await models.ResolveAsync(
            requestedModel.Provider, requestedModel.Model, cancellationToken);
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(),
            CreatedByAdminId = adminId,
            Title = string.IsNullOrWhiteSpace(request.Title) ? null : request.Title.Trim(),
            AssistantProvider = selectedModel.Provider,
            AssistantModel = selectedModel.Model,
            Status = AuthoringSessionStatus.Active
        };
        await repository.AddAsync(session, cancellationToken);
        return ToResponse(session);
    }

    public Task<IReadOnlyList<AuthoringProviderResponse>> ListProvidersAsync(CancellationToken cancellationToken) =>
        models.ListProvidersAsync(cancellationToken);

    public Task<IReadOnlyList<AuthoringModelResponse>> ListModelsAsync(CancellationToken cancellationToken) =>
        models.ListAsync(cancellationToken);

    public async Task<AuthoringSessionResponse> SetModelAsync(
        Guid sessionId,
        SetAuthoringModelRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringService.SetModel");
        var session = await RequiredMutableSessionAsync(sessionId, cancellationToken);
        if (session.Revision != request.ExpectedRevision)
            throw new InvalidOperationException("The authoring session is stale. Reload the session.");

        var selectedModel = await models.ResolveAsync(request.Provider, request.Model, cancellationToken);
        session.AssistantProvider = selectedModel.Provider;
        session.AssistantModel = selectedModel.Model;
        session.Revision++;
        await repository.SaveAsync(cancellationToken);
        return ToResponse(session);
    }

    public async Task<AuthoringTurnOutcome> AddMessageAsync(
        Guid sessionId, AddAuthoringMessageRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringService.AddMessage");
        if (string.IsNullOrWhiteSpace(request.Content)) throw new ArgumentException("Message content is required.");
        var session = await repository.GetAsync(sessionId, cancellationToken)
            ?? throw new KeyNotFoundException("The chat was not found.");
        await RecoverExpiredTurnAsync(session, cancellationToken);
        var previous = request.ClientRequestId is null ? null : session.Messages.SingleOrDefault(
            item => item.ClientRequestId == request.ClientRequestId);
        if (previous is not null)
        {
            if (previous.Content != request.Content.Trim())
                throw new ArgumentException("A request ID cannot be reused for a different message.");
            var completed = session.Messages.LastOrDefault(item => item.TurnId == previous.TurnId &&
                item.Role == AuthoringMessageRole.Assistant);
            if (completed is not null)
                return AuthoringTurnOutcome.Success(new AuthoringTurnResponse(ToResponse(session), completed.Content));
            if (session.LastTurnId != previous.TurnId) return AuthoringTurnOutcome.Conflict();
        }
        if (session.LastTurnStatus == "Running" ||
            session.Status is AuthoringSessionStatus.Published or AuthoringSessionStatus.Abandoned)
            return AuthoringTurnOutcome.Conflict();
        var adminMessage = previous ?? new PresetAuthoringMessage
        {
            Id = Guid.NewGuid(),
            SessionId = session.Id,
            Session = session,
            Sequence = NextSequence(session),
            Role = AuthoringMessageRole.Admin,
            ClientRequestId = request.ClientRequestId,
            TurnId = Guid.NewGuid(),
            Content = request.Content.Trim()
        };
        if (!await repository.TryAddMessageAsync(
                session, adminMessage, request.ExpectedRevision, cancellationToken))
            return AuthoringTurnOutcome.Conflict();
        try
        {
            await NotifySafelyAsync(sessionId, "TurnStarted", new { sessionId, turnId = session.LastTurnId }, cancellationToken);
            var selectedModel = await models.ResolveAsync(
                session.AssistantProvider ?? models.GetDefaultSelection().Provider,
                session.AssistantModel ?? models.GetDefaultSelection().Model,
                cancellationToken);
            var context = session.DraftJson is null ? request.Content.Trim() :
                $"Current saved draft (revision {session.DraftRevision}):\n{session.DraftJson}\n\nAdmin request:\n{request.Content.Trim()}";
            var response = await agent.ReplyAsync(sessionId,
                session.Messages.OrderBy(x => x.Sequence).ToList(), context, selectedModel, cancellationToken);
            var assistantMessage = new PresetAuthoringMessage
            {
                Id = Guid.NewGuid(),
                SessionId = session.Id,
                Session = session,
                Sequence = NextSequence(session),
                Role = AuthoringMessageRole.Assistant,
                TurnId = session.LastTurnId,
                Content = response
            };
            await repository.AddMessageAsync(session, assistantMessage, cancellationToken);
            session.LastTurnStatus = "Completed";
            session.LastTurnError = null;
            await repository.SaveAsync(CancellationToken.None);
            var result = new AuthoringTurnResponse(ToResponse(session), response);
            await NotifySafelyAsync(sessionId, "TurnCompleted", result, cancellationToken);
            return AuthoringTurnOutcome.Success(result);
        }
        catch (Exception exception)
        {
            session.LastTurnStatus = "Failed";
            session.LastTurnError = exception is OperationCanceledException
                ? "The assistant timed out. Your message and any saved draft changes are kept. Retry when ready."
                : "The assistant could not finish. Your message and any saved draft changes are kept. Retry when ready.";
            await repository.SaveAsync(CancellationToken.None);
            await NotifySafelyAsync(sessionId, "TurnFailed", new { message = session.LastTurnError }, CancellationToken.None);
            throw;
        }
    }

    public async Task<AuthoringSessionResponse> ValidateAsync(Guid sessionId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringService.Validate");
        var session = await RequiredMutableSessionAsync(sessionId, cancellationToken);
        if (session.DraftJson is null) throw new InvalidOperationException("The authoring session has no draft.");
        var result = await validator.ValidateAsync(PresetDraftSerializer.Deserialize(session.DraftJson), cancellationToken);
        session.ValidationJson = PresetDraftSerializer.Serialize(result);
        session.ValidatedDraftRevision = session.DraftRevision;
        session.Revision++;
        session.Status = result.IsValid ? AuthoringSessionStatus.ReadyToPublish : AuthoringSessionStatus.Active;
        await repository.SaveAsync(cancellationToken);
        await NotifySafelyAsync(sessionId, "ValidationChanged", result, cancellationToken);
        return ToResponse(session);
    }

    public async Task<AuthoringSessionResponse> SaveDraftAsync(
        Guid sessionId, SaveAuthoringDraftRequest request, CancellationToken cancellationToken)
    {
        var session = await RequiredMutableSessionAsync(sessionId, cancellationToken);
        if (session.Revision != request.ExpectedRevision)
            throw new AuthoringSessionConflictException("The draft changed. Compare your edits with the latest saved draft.");
        ArgumentNullException.ThrowIfNull(request.Draft);
        var validation = await validator.ValidateAsync(request.Draft, cancellationToken);
        session.DraftJson = PresetDraftSerializer.Serialize(request.Draft);
        session.Title = request.Draft.Title;
        session.Revision++;
        session.DraftRevision++;
        session.ValidatedDraftRevision = session.DraftRevision;
        session.ValidationJson = PresetDraftSerializer.Serialize(validation);
        session.Status = validation.IsValid ? AuthoringSessionStatus.ReadyToPublish : AuthoringSessionStatus.Active;
        await repository.SaveAsync(cancellationToken);
        await NotifySafelyAsync(sessionId, "DraftUpdated", new { sessionId }, cancellationToken);
        return ToResponse(session);
    }

    public async Task<AuthoringPreviewResponse> PreviewAsync(
        Guid sessionId, PreviewAuthoringDraftRequest request, CancellationToken cancellationToken)
    {
        var session = await repository.GetAsync(sessionId, cancellationToken)
            ?? throw new KeyNotFoundException("The chat was not found.");
        AuthoringSessionState.RequireIdle(session);
        if (session.Revision != request.ExpectedRevision)
            throw new AuthoringSessionConflictException("The draft changed. Reload before previewing.");
        var draft = session.DraftJson is null ? throw new ArgumentException("Save a draft before previewing.") :
            PresetDraftSerializer.Deserialize(session.DraftJson);
        var validation = await validator.ValidateAsync(draft, cancellationToken);
        return AuthoringDraftPreview.Build(draft, session.DraftRevision, validation, request.SampleInputs);
    }

    public Task<Guid> PublishAsync(
        Guid sessionId, Guid adminId, PublishPresetRequest request, CancellationToken cancellationToken) =>
        publisher.PublishAsync(sessionId, adminId, request.ExpectedRevision, cancellationToken);

    public async Task<AuthoringSessionResponse> AbandonAsync(
        Guid sessionId,
        CancellationToken cancellationToken)
    {
        var session = await RequiredMutableSessionAsync(sessionId, cancellationToken);
        session.Status = AuthoringSessionStatus.Abandoned;
        session.Revision++;
        await repository.SaveAsync(cancellationToken);
        return ToResponse(session);
    }

    public async Task<AuthoringSessionResponse> RestoreAsync(
        Guid sessionId,
        CancellationToken cancellationToken)
    {
        var session = await repository.GetAsync(sessionId, cancellationToken)
            ?? throw new KeyNotFoundException($"Authoring session '{sessionId}' was not found.");
        if (session.Status != AuthoringSessionStatus.Abandoned)
            throw new InvalidOperationException("Only an abandoned authoring chat can be restored.");

        var validation = PresetDraftSerializer.DeserializeValidation(session.ValidationJson);
        session.Status = session.DraftJson is not null && validation.IsValid
            ? AuthoringSessionStatus.ReadyToPublish
            : AuthoringSessionStatus.Active;
        session.Revision++;
        await repository.SaveAsync(cancellationToken);
        return ToResponse(session);
    }

    public async Task DeleteAsync(Guid sessionId, CancellationToken cancellationToken)
    {
        var session = await repository.GetAsync(sessionId, cancellationToken)
            ?? throw new KeyNotFoundException($"Authoring session '{sessionId}' was not found.");
        AuthoringSessionState.RequireIdle(session);
        await repository.DeleteAsync(session, cancellationToken);
    }

    public async Task<IReadOnlyList<CapabilityResponse>> ListCapabilitiesAsync(CancellationToken cancellationToken)
    {
        var integrations = (await capabilities.ListIntegrationsAsync(cancellationToken)).Where(x => x.IsEnabled)
            .Select(x => new CapabilityResponse(x.Key, "Integration", x.DisplayName, x.Description,
                x.Connector?.Key, x.InputSchemaJson, x.OutputSchemaJson, x.RequiredOAuthScopesJson,
                x.RequiredApisJson, x.DocumentationLinksJson, x.RiskLevel.ToString(),
                x.SupportsBackgroundExecution));
        var operations = (await capabilities.ListOperationsAsync(cancellationToken)).Where(x => x.IsEnabled)
            .Select(x => new CapabilityResponse(x.Key, "Operation", x.DisplayName, x.Description,
                null, x.InputSchemaJson, x.OutputSchemaJson, "[]", "[]", "[]", "None",
                x.SupportsBackgroundExecution));
        return integrations.Concat(operations).OrderBy(x => x.Key).ToList();
    }

    private async Task<PresetAuthoringSession> RequiredMutableSessionAsync(
        Guid sessionId, CancellationToken cancellationToken)
    {
        var session = await repository.GetAsync(sessionId, cancellationToken)
            ?? throw new KeyNotFoundException($"Authoring session '{sessionId}' was not found.");
        await RecoverExpiredTurnAsync(session, cancellationToken);
        AuthoringSessionState.RequireIdle(session);
        if (session.Status is AuthoringSessionStatus.Published or AuthoringSessionStatus.Abandoned)
            throw new InvalidOperationException("The authoring session can no longer be modified.");
        return session;
    }

    private static int NextSequence(PresetAuthoringSession session) =>
        session.Messages.Count == 0 ? 1 : session.Messages.Max(x => x.Sequence) + 1;

    public static AuthoringSessionResponse ToResponse(PresetAuthoringSession session)
    {
        var validation = PresetDraftSerializer.DeserializeValidation(session.ValidationJson);
        var draft = session.DraftJson is null ? null : PresetDraftSerializer.Deserialize(session.DraftJson);
        var assistantModel = new AuthoringModelSelectionResponse(
            session.AssistantProvider ?? "unconfigured",
            session.AssistantModel ?? "unconfigured");
        return new AuthoringSessionResponse(session.Id, session.Title, session.Status.ToString(), session.Revision,
            assistantModel,
            draft, validation, session.PublishedPresetId,
            session.Messages.OrderBy(x => x.Sequence).Select(x => new AuthoringMessageResponse(
                x.Id, x.Sequence, x.Role.ToString(), x.Content, x.ToolName, x.CreatedAtUtc)).ToList(),
            session.CreatedAtUtc, session.UpdatedAtUtc, session.DraftRevision, session.ValidatedDraftRevision,
            session.LastTurnId is { } turnId ? new AuthoringTurnStateResponse(turnId,
                session.LastTurnStatus ?? "Failed", session.TurnStartedAtUtc, session.LastTurnError) : null,
            AuthoringSessionState.Readiness(session));
    }

    private async Task RecoverExpiredTurnAsync(PresetAuthoringSession session, CancellationToken cancellationToken)
    {
        if (session.LastTurnStatus != "Running" || session.TurnStartedAtUtc > DateTimeOffset.UtcNow.AddMinutes(-6)) return;
        var completed = session.Messages.Any(item => item.TurnId == session.LastTurnId && item.Role == AuthoringMessageRole.Assistant);
        session.LastTurnStatus = completed ? "Completed" : "Failed";
        session.LastTurnError = completed ? null : "The assistant was interrupted. Your saved work is kept; retry when ready.";
        session.Revision++;
        await repository.SaveAsync(cancellationToken);
    }

    private async Task NotifySafelyAsync(Guid sessionId, string eventName, object payload, CancellationToken cancellationToken)
    {
        try { await realtime.NotifyAsync(sessionId, eventName, payload, cancellationToken); }
        catch (Exception exception)
        {
            logger?.LogWarning(exception, "Authoring realtime notification {EventName} failed for {SessionId}", eventName, sessionId);
        }
    }
}
