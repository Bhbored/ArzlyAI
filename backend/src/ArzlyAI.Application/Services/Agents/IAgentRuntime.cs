using ArzlyAI.Domain.Presets;
namespace ArzlyAI.Application.Services.Agents;
public interface IAgentRuntime
{
    Task<string> ExecuteAsync(
        AgentDefinition agent,
        string input,
        string model,
        double? temperature,
        string apiKey,
        CancellationToken cancellationToken);
}
