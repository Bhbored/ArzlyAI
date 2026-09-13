using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftDocument(
    string Key,
    string Title,
    string Subtitle,
    string Description,
    string DetailedDescription,
    string InputSchemaJson,
    string? ResultContractKey,
    int? ResultContractVersion,
    BackgroundExecutionPolicyDraft BackgroundExecution,
    IReadOnlyList<PresetDraftAgent> Agents,
    PresetDraftWorkflow Workflow,
    IReadOnlyList<PresetDraftAdminNote> AdminNotes);
