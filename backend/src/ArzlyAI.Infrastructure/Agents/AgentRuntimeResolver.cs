using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Services.Agents;

namespace ArzlyAI.Infrastructure.Agents;

public sealed class AgentRuntimeResolver(IEnumerable<IAgentRuntime> runtimes) : IAgentRuntimeResolver
{
    private readonly IReadOnlyDictionary<string, IAgentRuntime> runtimesByKey =
        runtimes.ToDictionary(runtime => runtime.ProviderKey, StringComparer.OrdinalIgnoreCase);

    public IAgentRuntime Resolve(string providerKey)
    {
        var normalized = providerKey.ToLowerInvariant();
        if (!AiProviderKeys.IsSupported(normalized))
            throw new ArgumentException($"Provider '{providerKey}' is not supported.");
        return runtimesByKey.TryGetValue(normalized, out var runtime)
            ? runtime
            : throw new InvalidOperationException($"No agent runtime is registered for '{providerKey}'.");
    }
}
