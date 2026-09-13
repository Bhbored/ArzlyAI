using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Authoring;

public sealed class PresetAuthoringService(
    IPresetAuthoringRepository repository,
    ICapabilityCatalogRepository capabilities,
    IPresetAuthoringAgent agent,
    IAuthoringModelCatalogService models,
    IPresetDraftValidator validator,
    IPresetPublisher publisher,
    IAuthoringRealtimeNotifier realtime) : IPresetAuthoringService
{
    public async Task<IReadOnlyList<AuthoringSessionResponse>> ListAsync(CancellationToken cancellationToken) =>
        (await repository.ListAsync(cancellationToken)).Select(ToResponse).ToList();

    public async Task<AuthoringSessionResponse?> GetAsync(Guid sessionId, CancellationToken cancellationToken)
    {
        var session = await repository.GetAsync(sessionId, cancellationToken);
        return session is null ? null : ToResponse(session);
    }

    public async Task<AuthoringSessionResponse> CreateAsync(
        Guid adminId, CreateAuthoringSessionRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringService.Create");
        var selectedModel = string.IsNullOrWhiteSpace(request.Provider) || string.IsNullOrWhiteSpace(request.Model)
            ? models.GetDefaultSelection()
            : await models.ResolveAsync(request.Provider, request.Model, cancellationToken);
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(), CreatedByAdminId = adminId,
            Title = string.IsNullOrWhiteSpace(request.Title) ? null : request.Title.Trim(),
            AssistantProvider = selectedModel.Provider, AssistantModel = selectedModel.Model,
            Status = AuthoringSessionStatus.Active
        };
        await repository.AddAsync(session, cancellationToken);
        return ToResponse(session);
    }

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

    public async Task<AuthoringTurnResponse> AddMessageAsync(
        Guid sessionId, AddAuthoringMessageRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringService.AddMessage");
        if (string.IsNullOrWhiteSpace(request.Content)) throw new ArgumentException("Message content is required.");
        var session = await RequiredMutableSessionAsync(sessionId, cancellationToken);
        if (session.Revision != request.ExpectedRevision)
            throw new InvalidOperationException("The draft revision is stale. Reload the session.");
        session.Messages.Add(new PresetAuthoringMessage
        {
            Id = Guid.NewGuid(), SessionId = session.Id, Session = session,
            Sequence = NextSequence(session), Role = AuthoringMessageRole.Admin,
            Content = request.Content.Trim()
        });
        await repository.SaveAsync(cancellationToken);
        await realtime.NotifyAsync(sessionId, "TurnStarted", new { sessionId }, cancellationToken);

        try
        {
            var selectedModel = await models.ResolveAsync(
                session.AssistantProvider ?? models.GetDefaultSelection().Provider,
                session.AssistantModel ?? models.GetDefaultSelection().Model,
                cancellationToken);
            var response = await agent.ReplyAsync(sessionId,
                session.Messages.OrderBy(x => x.Sequence).ToList(), request.Content.Trim(), selectedModel, cancellationToken);
            session.Messages.Add(new PresetAuthoringMessage
            {
                Id = Guid.NewGuid(), SessionId = session.Id, Session = session,
                Sequence = NextSequence(session), Role = AuthoringMessageRole.Assistant, Content = response
            });
            await repository.SaveAsync(cancellationToken);
            var result = new AuthoringTurnResponse(ToResponse(session), response);
            await realtime.NotifyAsync(sessionId, "TurnCompleted", result, cancellationToken);
            return result;
        }
        catch (Exception exception)
        {
            await realtime.NotifyAsync(sessionId, "TurnFailed", new { message = exception.Message }, cancellationToken);
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
        session.Status = result.IsValid ? AuthoringSessionStatus.ReadyToPublish : AuthoringSessionStatus.Active;
        await repository.SaveAsync(cancellationToken);
        await realtime.NotifyAsync(sessionId, "ValidationChanged", result, cancellationToken);
        return ToResponse(session);
    }

    public Task<Guid> PublishAsync(
        Guid sessionId, Guid adminId, PublishPresetRequest request, CancellationToken cancellationToken) =>
        publisher.PublishAsync(sessionId, adminId, request.ExpectedRevision, cancellationToken);

    public async Task AbandonAsync(Guid sessionId, CancellationToken cancellationToken)
    {
        var session = await RequiredMutableSessionAsync(sessionId, cancellationToken);
        session.Status = AuthoringSessionStatus.Abandoned;
        await repository.SaveAsync(cancellationToken);
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
        if (session.Status is AuthoringSessionStatus.Published or AuthoringSessionStatus.Abandoned)
            throw new InvalidOperationException("The authoring session can no longer be modified.");
        return session;
    }

    private static int NextSequence(PresetAuthoringSession session) =>
        session.Messages.Count == 0 ? 1 : session.Messages.Max(x => x.Sequence) + 1;

    private static AuthoringSessionResponse ToResponse(PresetAuthoringSession session)
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
            session.CreatedAtUtc, session.UpdatedAtUtc);
    }
}
