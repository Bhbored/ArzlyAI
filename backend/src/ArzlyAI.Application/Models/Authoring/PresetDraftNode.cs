using ArzlyAI.Domain.Enums;
using System.Text.Json.Serialization;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftNode(
    string Key,
    string DisplayName,
    [property: JsonConverter(typeof(JsonStringEnumConverter))] WorkflowNodeType Type,
    string ReferenceKey,
    int Position,
    string InputMappingJson,
    bool RequiresHumanApproval,
    string? ConfigurationJson,
    string? ResultContractKey,
    int? ResultContractVersion,
    AuthoringCanvasPosition? EditorPosition = null);
