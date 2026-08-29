namespace ArzlyAI.Application.DTOs.Presets;
public sealed record AgentResponse(
    string Key,
    string Name,
    string SystemPrompt,
    bool IsSystemPromptEditable,
    AgentModelConfigurationResponse ModelConfiguration,
    AgentHarnessResponse Harness);
