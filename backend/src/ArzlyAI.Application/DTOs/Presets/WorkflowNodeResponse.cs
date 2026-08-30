namespace ArzlyAI.Application.DTOs.Presets;
public sealed record WorkflowNodeResponse(
    Guid Id,
    string Key,
    string DisplayName,
    string Type,
    int Position,
    bool RequiresHumanApproval,
    string? ConfigurationJson,
    ResultContractResponse? ResultContract);
