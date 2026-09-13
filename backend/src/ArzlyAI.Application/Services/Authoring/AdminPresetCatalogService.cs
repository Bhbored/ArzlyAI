using System.Text.Json;
using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.DTOs.Admin.Presets;
using ArzlyAI.Application.Mappers.Presets;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Authoring;

public sealed class AdminPresetCatalogService(
    IPresetPublishingRepository presets,
    IPresetAuthoringRepository sessions,
    IPresetMapper mapper,
    IPresetDraftValidator validator,
    IAuthoringModelCatalogService models) : IAdminPresetCatalogService
{
    public async Task<IReadOnlyList<AdminPresetSummaryResponse>> ListAsync(CancellationToken cancellationToken) =>
        (await presets.ListVersionsAsync(cancellationToken)).Select(x => new AdminPresetSummaryResponse(
            x.Id, x.Key, x.Name, x.Version, x.Status.ToString(), x.PublishedAtUtc)).ToList();

    public async Task<AdminPresetDetailsResponse?> GetAsync(
        string key, int version, CancellationToken cancellationToken)
    {
        var preset = await presets.GetVersionAsync(key, version, cancellationToken);
        return preset is null ? null : new AdminPresetDetailsResponse(mapper.ToDetailsResponse(preset),
            preset.Status.ToString(), preset.PublishedByAdminId, preset.SupersedesPresetId,
            preset.AdminNotes.OrderBy(x => x.DisplayOrder).Select(x => new AdminNoteResponse(
                x.Title, x.Description, x.Severity.ToString(), x.LinksJson, x.DisplayOrder)).ToList());
    }

    public async Task<AuthoringSessionResponse> CloneToDraftAsync(
        string key, int version, Guid adminId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AdminPresetCatalogService.CloneToDraft");
        var preset = await presets.GetVersionAsync(key, version, cancellationToken)
            ?? throw new KeyNotFoundException($"Preset '{key}' version {version} was not found.");
        var draft = ToDraft(preset);
        var validation = await validator.ValidateAsync(draft, cancellationToken);
        var assistantModel = models.GetDefaultSelection();
        var session = new PresetAuthoringSession
        {
            Id = Guid.NewGuid(), CreatedByAdminId = adminId, Title = preset.Name,
            AssistantProvider = assistantModel.Provider, AssistantModel = assistantModel.Model,
            Status = validation.IsValid ? AuthoringSessionStatus.ReadyToPublish : AuthoringSessionStatus.Active,
            DraftJson = PresetDraftSerializer.Serialize(draft),
            ValidationJson = PresetDraftSerializer.Serialize(validation), Revision = 1
        };
        await sessions.AddAsync(session, cancellationToken);
        return new AuthoringSessionResponse(session.Id, session.Title, session.Status.ToString(), session.Revision,
            new AuthoringModelSelectionResponse(assistantModel.Provider, assistantModel.Model),
            draft, validation, null, [], session.CreatedAtUtc, session.UpdatedAtUtc);
    }

    public async Task ArchiveAsync(string key, int version, CancellationToken cancellationToken)
    {
        var preset = await presets.GetVersionAsync(key, version, cancellationToken)
            ?? throw new KeyNotFoundException($"Preset '{key}' version {version} was not found.");
        await presets.ArchiveAsync(preset, cancellationToken);
    }

    private static PresetDraftDocument ToDraft(PresetDefinition preset) => new(
        preset.Key, preset.Name, preset.Subtitle ?? string.Empty, preset.Description,
        preset.DetailedDescription ?? preset.Description, preset.InputSchemaJson ?? "{}",
        preset.ResultContractKey, preset.ResultContractVersion,
        new BackgroundExecutionPolicyDraft(preset.BackgroundExecutionMode,
            preset.BackgroundExecutionRationale ?? string.Empty,
            JsonSerializer.Deserialize<List<string>>(preset.AllowedTriggerTypesJson) ?? []),
        preset.Agents.OrderBy(x => x.Key).Select(x => new PresetDraftAgent(
            x.Key, x.Name, x.Instructions, x.RuntimeType, x.Model.Provider.Key, x.Model.Key,
            x.DefaultTemperature, x.MinimumTemperature, x.MaximumTemperature,
            x.AllowModelOverride, x.AllowTemperatureOverride, x.OutputSchemaJson,
            new PresetDraftHarness(x.Harness.PlanningEnabled, x.Harness.TodoTrackingEnabled,
                x.Harness.ContextCompactionEnabled, x.Harness.RequireToolApproval,
                x.Harness.MaxIterations, x.Harness.WebSearchEnabled))).ToList(),
        new PresetDraftWorkflow(preset.Workflow.Key,
            preset.Workflow.Steps.OrderBy(x => x.Position).Select(x => new PresetDraftNode(
                x.Key, x.DisplayName, x.Type, x.ReferenceKey, x.Position, x.InputMappingJson,
                x.RequiresHumanApproval, x.ConfigurationJson, x.ResultContractKey,
                x.ResultContractVersion)).ToList(),
            preset.Workflow.Connections.Select(x => new PresetDraftConnection(
                preset.Workflow.Steps.Single(step => step.Id == x.SourceStepId).Key,
                preset.Workflow.Steps.Single(step => step.Id == x.TargetStepId).Key)).ToList()),
        preset.AdminNotes.OrderBy(x => x.DisplayOrder).Select(x => new PresetDraftAdminNote(
            x.Title, x.Description, x.Severity,
            JsonSerializer.Deserialize<List<string>>(x.LinksJson) ?? [])).ToList());
}
