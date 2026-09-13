using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Authoring;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Authoring;

public sealed class PresetAuthoringToolbox(
    IPresetAuthoringRepository sessions,
    ICapabilityCatalogRepository catalog,
    IPresetDraftValidator validator) : IPresetAuthoringToolbox
{
    public async Task<string> ListCapabilitiesAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringToolbox.ListCapabilities");
        return PresetDraftSerializer.Serialize(await BuildCapabilitiesAsync(cancellationToken));
    }

    public async Task<string> GetCapabilityDetailsAsync(string key, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringToolbox.GetCapabilityDetails");
        var capability = (await BuildCapabilitiesAsync(cancellationToken))
            .SingleOrDefault(x => string.Equals(x.Key, key, StringComparison.Ordinal));
        return capability is null
            ? PresetDraftSerializer.Serialize(new { error = $"Capability '{key}' is not registered." })
            : PresetDraftSerializer.Serialize(capability);
    }

    public async Task<string> SaveDraftAsync(
        Guid sessionId, string draftJson, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringToolbox.SaveDraft");
        var session = await RequiredSessionAsync(sessionId, cancellationToken);
        var draft = PresetDraftSerializer.Deserialize(draftJson);
        var validation = await validator.ValidateAsync(draft, cancellationToken);
        session.DraftJson = PresetDraftSerializer.Serialize(draft);
        session.ValidationJson = PresetDraftSerializer.Serialize(validation);
        session.Title = draft.Title;
        session.Revision++;
        session.Status = validation.IsValid
            ? AuthoringSessionStatus.ReadyToPublish
            : AuthoringSessionStatus.Active;
        await sessions.SaveAsync(cancellationToken);
        return session.ValidationJson;
    }

    public async Task<string> ValidateDraftAsync(Guid sessionId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringToolbox.ValidateDraft");
        var session = await RequiredSessionAsync(sessionId, cancellationToken);
        if (session.DraftJson is null) return "{\"isValid\":false,\"errors\":[{\"path\":\"draft\",\"message\":\"No draft exists.\"}]}";
        var validation = await validator.ValidateAsync(PresetDraftSerializer.Deserialize(session.DraftJson), cancellationToken);
        session.ValidationJson = PresetDraftSerializer.Serialize(validation);
        session.Status = validation.IsValid ? AuthoringSessionStatus.ReadyToPublish : AuthoringSessionStatus.Active;
        await sessions.SaveAsync(cancellationToken);
        return session.ValidationJson;
    }

    public async Task RecordToolResultAsync(
        Guid sessionId, string toolName, string resultJson, CancellationToken cancellationToken)
    {
        var session = await RequiredSessionAsync(sessionId, cancellationToken);
        session.Messages.Add(new PresetAuthoringMessage
        {
            Id = Guid.NewGuid(), SessionId = session.Id, Session = session,
            Sequence = session.Messages.Count == 0 ? 1 : session.Messages.Max(x => x.Sequence) + 1,
            Role = AuthoringMessageRole.Tool, Content = $"{toolName} completed.",
            ToolName = toolName, ToolPayloadJson = resultJson
        });
        await sessions.SaveAsync(cancellationToken);
    }

    private async Task<IReadOnlyList<CapabilityResponse>> BuildCapabilitiesAsync(CancellationToken cancellationToken)
    {
        var integrations = (await catalog.ListIntegrationsAsync(cancellationToken)).Where(x => x.IsEnabled)
            .Select(x => new CapabilityResponse(x.Key, "Integration", x.DisplayName, x.Description,
                x.Connector?.Key, x.InputSchemaJson, x.OutputSchemaJson, x.RequiredOAuthScopesJson,
                x.RequiredApisJson, x.DocumentationLinksJson, x.RiskLevel.ToString(),
                x.SupportsBackgroundExecution));
        var operations = (await catalog.ListOperationsAsync(cancellationToken)).Where(x => x.IsEnabled)
            .Select(x => new CapabilityResponse(x.Key, "Operation", x.DisplayName, x.Description,
                null, x.InputSchemaJson, x.OutputSchemaJson, "[]", "[]", "[]", "None",
                x.SupportsBackgroundExecution));
        return integrations.Concat(operations).OrderBy(x => x.Key).ToList();
    }

    private async Task<PresetAuthoringSession> RequiredSessionAsync(
        Guid sessionId, CancellationToken cancellationToken)
    {
        var session = await sessions.GetAsync(sessionId, cancellationToken)
            ?? throw new KeyNotFoundException($"Authoring session '{sessionId}' was not found.");
        if (session.Status is AuthoringSessionStatus.Published or AuthoringSessionStatus.Abandoned)
            throw new InvalidOperationException("The authoring session can no longer be modified.");
        return session;
    }
}
