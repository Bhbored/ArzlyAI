using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Tests;

public sealed class PresetAuthoringServiceTests
{
    [Fact]
    public async Task CreateAsync_WhenVisualBuilderHasNoAvailableAssistant_CreatesEditableSession()
    {
        var service = new PresetAuthoringService(
            new StubAuthoringRepository(new PresetAuthoringSession { Id = Guid.NewGuid(), CreatedByAdminId = Guid.NewGuid() }),
            new StubCapabilityCatalog(), new StubAuthoringAgent(), new StubModelCatalog(rejectSelection: true),
            new StubDraftValidator(), new StubPublisher(), new StubRealtimeNotifier());

        var result = await service.CreateAsync(Guid.NewGuid(),
            new CreateAuthoringSessionRequest("Visual workflow", UseVisualBuilder: true), CancellationToken.None);

        Assert.Equal("Active", result.Status);
        Assert.Equal("Visual workflow", result.Title);
        Assert.Null(result.Draft);
        Assert.Empty(result.Messages);
    }

    [Fact]
    public async Task RestoreAsync_WhenAbandonedDraftIsValid_RestoresReadyToPublish()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(),
            CreatedByAdminId = Guid.NewGuid(),
            Status = AuthoringSessionStatus.Abandoned,
            Revision = 3,
            DraftJson = PresetDraftSerializer.Serialize(new PresetDraftDocument(
                "restored-chat",
                "Restored chat",
                "Restored subtitle",
                "Restored draft",
                "Restored draft details",
                "{\"type\":\"object\"}",
                null,
                null,
                new BackgroundExecutionPolicyDraft(
                    BackgroundExecutionMode.NotApplicable,
                    "No background execution.",
                    []),
                [],
                new PresetDraftWorkflow("workflow", [], []),
                [])),
            ValidationJson = PresetDraftSerializer.Serialize(
                new PresetValidationResult([]))
        };
        var repository = new StubAuthoringRepository(session);
        var service = CreateService(repository);

        var result = await service.RestoreAsync(session.Id, CancellationToken.None);

        Assert.Equal(AuthoringSessionStatus.ReadyToPublish.ToString(), result.Status);
        Assert.Equal(4, result.Revision);
        Assert.Equal(1, repository.SaveCount);
    }

    [Fact]
    public async Task DeleteAsync_WhenChatIsAbandoned_DeletesItPermanently()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(),
            CreatedByAdminId = Guid.NewGuid(),
            Status = AuthoringSessionStatus.Abandoned
        };
        var repository = new StubAuthoringRepository(session);
        var service = CreateService(repository);

        await service.DeleteAsync(session.Id, CancellationToken.None);

        Assert.Equal(1, repository.DeleteCount);
    }

    [Fact]
    public async Task CreateAsync_WhenDefaultModelIsUnavailable_RejectsSession()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(),
            CreatedByAdminId = Guid.NewGuid(),
            Status = AuthoringSessionStatus.Active
        };
        var service = new PresetAuthoringService(
            new StubAuthoringRepository(session),
            new StubCapabilityCatalog(),
            new StubAuthoringAgent(),
            new StubModelCatalog(rejectSelection: true),
            new StubDraftValidator(),
            new StubPublisher(),
            new StubRealtimeNotifier());

        await Assert.ThrowsAsync<ArgumentException>(() => service.CreateAsync(
            Guid.NewGuid(),
            new CreateAuthoringSessionRequest("Unavailable default"),
            CancellationToken.None));
    }

    [Fact]
    public async Task AddMessageAsync_WhenRevisionIsCurrent_IncrementsRevisionAndAddsTurn()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(),
            CreatedByAdminId = Guid.NewGuid(),
            AssistantProvider = "test",
            AssistantModel = "test-model",
            Status = AuthoringSessionStatus.Active,
            Revision = 4
        };
        var repository = new StubAuthoringRepository(session);
        var service = new PresetAuthoringService(
            repository,
            new StubCapabilityCatalog(),
            new StubAuthoringAgent(),
            new StubModelCatalog(),
            new StubDraftValidator(),
            new StubPublisher(),
            new StubRealtimeNotifier());

        var result = await service.AddMessageAsync(
            session.Id,
            new AddAuthoringMessageRequest("Update the draft", 4),
            CancellationToken.None);

        Assert.False(result.IsConflict);
        Assert.NotNull(result.Response);
        Assert.Equal(5, result.Response.Session.Revision);
        Assert.Equal("Assistant response", result.Response.AssistantMessage);
        Assert.Equal(2, result.Response.Session.Messages.Count);
        Assert.Equal(3, repository.SaveCount);
    }

    [Fact]
    public async Task AddMessageAsync_WhenAtomicRevisionClaimFails_ReturnsConflictWithoutStartingTurn()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(),
            CreatedByAdminId = Guid.NewGuid(),
            AssistantProvider = "test",
            AssistantModel = "test-model",
            Status = AuthoringSessionStatus.Active,
            Revision = 5
        };
        var repository = new StubAuthoringRepository(session);
        var service = new PresetAuthoringService(
            repository,
            new StubCapabilityCatalog(),
            new StubAuthoringAgent(),
            new StubModelCatalog(),
            new StubDraftValidator(),
            new StubPublisher(),
            new StubRealtimeNotifier());

        var result = await service.AddMessageAsync(
            session.Id,
            new AddAuthoringMessageRequest("Stale edit", 4),
            CancellationToken.None);

        Assert.True(result.IsConflict);
        Assert.Null(result.Response);
        Assert.Empty(session.Messages);
        Assert.Equal(0, repository.SaveCount);
    }

    [Fact]
    public async Task AddMessageAsync_WhenRequestIsRepeated_ReturnsSavedAssistantWithoutAppendingAnotherTurn()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(), CreatedByAdminId = Guid.NewGuid(), Status = AuthoringSessionStatus.Active,
            AssistantProvider = "test", AssistantModel = "test-model"
        };
        var repository = new StubAuthoringRepository(session);
        var service = CreateService(repository);
        var request = new AddAuthoringMessageRequest("Please update", 0, Guid.NewGuid());

        var first = await service.AddMessageAsync(session.Id, request, CancellationToken.None);
        var second = await service.AddMessageAsync(session.Id, request, CancellationToken.None);

        Assert.False(second.IsConflict);
        Assert.Equal(first.Response?.AssistantMessage, second.Response?.AssistantMessage);
        Assert.Equal(2, session.Messages.Count);
        Assert.Equal(3, repository.SaveCount);
    }

    [Fact]
    public async Task AddMessageAsync_WhenAnotherTurnIsRunning_DoesNotAppendMessage()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(), CreatedByAdminId = Guid.NewGuid(), Status = AuthoringSessionStatus.Active,
            AssistantProvider = "test", AssistantModel = "test-model", LastTurnStatus = "Running",
            TurnStartedAtUtc = DateTimeOffset.UtcNow
        };
        var repository = new StubAuthoringRepository(session);
        var result = await CreateService(repository).AddMessageAsync(session.Id,
            new AddAuthoringMessageRequest("Overlapping message", 0, Guid.NewGuid()), CancellationToken.None);

        Assert.True(result.IsConflict);
        Assert.Empty(session.Messages);
    }

    [Fact]
    public async Task SaveDraftAsync_WhenRevisionIsStale_PreservesSavedDraft()
    {
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(), CreatedByAdminId = Guid.NewGuid(), Status = AuthoringSessionStatus.Active,
            Revision = 3, DraftJson = "{\"key\":\"original\"}"
        };
        var draft = new PresetDraftDocument("new", "New", "Subtitle", "Description", "Details", "{}", null, null,
            new BackgroundExecutionPolicyDraft(BackgroundExecutionMode.NotApplicable, "", []), [],
            new PresetDraftWorkflow("workflow", [], []), []);
        var service = CreateService(new StubAuthoringRepository(session));

        await Assert.ThrowsAsync<AuthoringSessionConflictException>(() => service.SaveDraftAsync(session.Id,
            new SaveAuthoringDraftRequest(2, draft), CancellationToken.None));
        Assert.Equal("{\"key\":\"original\"}", session.DraftJson);
    }

    private sealed class StubAuthoringRepository(PresetAuthoringSession session) : IPresetAuthoringRepository
    {
        public int DeleteCount { get; private set; }
        public int SaveCount { get; private set; }

        public Task<IReadOnlyList<PresetAuthoringSession>> ListAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<PresetAuthoringSession>>([session]);

        public Task<PresetAuthoringSession?> GetAsync(Guid id, CancellationToken cancellationToken) =>
            Task.FromResult<PresetAuthoringSession?>(id == session.Id ? session : null);

        public Task AddAsync(PresetAuthoringSession value, CancellationToken cancellationToken) => Task.CompletedTask;

        public Task<bool> TryAddMessageAsync(
            PresetAuthoringSession value,
            PresetAuthoringMessage message,
            int expectedRevision,
            CancellationToken cancellationToken)
        {
            if (value.Revision != expectedRevision) return Task.FromResult(false);
            value.Revision++;
            value.LastTurnId = message.TurnId;
            value.LastTurnStatus = "Running";
            value.Messages.Add(message);
            SaveCount++;
            return Task.FromResult(true);
        }

        public Task AddMessageAsync(
            PresetAuthoringSession value,
            PresetAuthoringMessage message,
            CancellationToken cancellationToken)
        {
            value.Messages.Add(message);
            SaveCount++;
            return Task.CompletedTask;
        }

        public Task SaveAsync(CancellationToken cancellationToken)
        {
            SaveCount++;
            return Task.CompletedTask;
        }

        public Task DeleteAsync(
            PresetAuthoringSession value,
            CancellationToken cancellationToken)
        {
            DeleteCount++;
            return Task.CompletedTask;
        }
    }

    private static PresetAuthoringService CreateService(StubAuthoringRepository repository) =>
        new(
            repository,
            new StubCapabilityCatalog(),
            new StubAuthoringAgent(),
            new StubModelCatalog(),
            new StubDraftValidator(),
            new StubPublisher(),
            new StubRealtimeNotifier());

    private sealed class StubCapabilityCatalog : ICapabilityCatalogRepository
    {
        public Task<IReadOnlyList<IntegrationDefinition>> ListIntegrationsAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<IntegrationDefinition>>([]);

        public Task<IReadOnlyList<WorkflowOperationDefinition>> ListOperationsAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<WorkflowOperationDefinition>>([]);

        public Task<IReadOnlyList<ModelDefinition>> ListModelsAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<ModelDefinition>>([]);
    }

    private sealed class StubAuthoringAgent : IPresetAuthoringAgent
    {
        public Task<string> ReplyAsync(
            Guid sessionId,
            IReadOnlyList<PresetAuthoringMessage> history,
            string message,
            AuthoringModelSelection model,
            CancellationToken cancellationToken) => Task.FromResult("Assistant response");
    }

    private sealed class StubModelCatalog(bool rejectSelection = false) : IAuthoringModelCatalogService
    {
        private static readonly AuthoringModelSelection Selection = new("test", "test-model");

        public Task<IReadOnlyList<AuthoringProviderResponse>> ListProvidersAsync(
            CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<AuthoringProviderResponse>>([]);

        public Task<IReadOnlyList<AuthoringModelResponse>> ListAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<AuthoringModelResponse>>([]);

        public Task<AuthoringModelSelection> ResolveAsync(
            string provider,
            string model,
            CancellationToken cancellationToken) => rejectSelection
            ? throw new ArgumentException("The model is unavailable.")
            : Task.FromResult(Selection);

        public AuthoringModelSelection GetDefaultSelection() => Selection;
    }

    private sealed class StubDraftValidator : IPresetDraftValidator
    {
        public Task<PresetValidationResult> ValidateAsync(
            PresetDraftDocument draft,
            CancellationToken cancellationToken) => throw new NotSupportedException();
    }

    private sealed class StubPublisher : IPresetPublisher
    {
        public Task<Guid> PublishAsync(
            Guid sessionId,
            Guid adminId,
            int expectedRevision,
            CancellationToken cancellationToken) => throw new NotSupportedException();
    }

    private sealed class StubRealtimeNotifier : IAuthoringRealtimeNotifier
    {
        public Task NotifyAsync(
            Guid sessionId,
            string eventName,
            object payload,
            CancellationToken cancellationToken) => Task.CompletedTask;
    }
}
