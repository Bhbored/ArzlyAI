namespace ArzlyAI.Application.Services.Agents;

public interface IAgentRuntimeResolver
{
    IAgentRuntime Resolve(string providerKey);
}
