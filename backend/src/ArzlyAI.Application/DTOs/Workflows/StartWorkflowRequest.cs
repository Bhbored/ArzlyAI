using ArzlyAI.Application.Security;
namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record StartWorkflowRequest(
    string PresetKey,
    IReadOnlyDictionary<string, string> Inputs,
    IReadOnlyList<AgentOverrideRequest> AgentOverrides,
    CredentialEnvelope Credentials);
