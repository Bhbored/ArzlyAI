namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record AgentOverrideRequest(string AgentKey, string? Model, double? Temperature);
