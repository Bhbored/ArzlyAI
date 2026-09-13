using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftNode(
    string Key,
    string DisplayName,
    WorkflowNodeType Type,
    string ReferenceKey,
    int Position,
    string InputMappingJson,
    bool RequiresHumanApproval,
    string? ConfigurationJson,
    string? ResultContractKey,
    int? ResultContractVersion);
