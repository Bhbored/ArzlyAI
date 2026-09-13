namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftWorkflow(
    string Key,
    IReadOnlyList<PresetDraftNode> Nodes,
    IReadOnlyList<PresetDraftConnection> Connections);
