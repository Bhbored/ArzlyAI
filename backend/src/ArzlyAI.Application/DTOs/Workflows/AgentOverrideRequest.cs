namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record AgentOverrideRequest(
    string AgentKey,
    string? Provider,
    string? Model,
    double? Temperature);
