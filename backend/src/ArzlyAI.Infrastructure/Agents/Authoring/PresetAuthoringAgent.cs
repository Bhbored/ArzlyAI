using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Domain.Authoring;
using Microsoft.Extensions.Options;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class PresetAuthoringAgent(
    IEnumerable<IPresetAuthoringProviderAgent> providerAgents,
    IOptions<PresetAuthoringOptions> options) : IPresetAuthoringAgent
{
    private readonly IReadOnlyDictionary<string, IPresetAuthoringProviderAgent> agentsByProvider =
        providerAgents.ToDictionary(agent => agent.ProviderKey, StringComparer.OrdinalIgnoreCase);

    public async Task<string> ReplyAsync(
        Guid sessionId,
        IReadOnlyList<PresetAuthoringMessage> history,
        string message,
        AuthoringModelSelection model,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringAgent.Reply");
        if (!agentsByProvider.TryGetValue(model.Provider, out var agent))
            throw new InvalidOperationException(
                $"Provider '{model.Provider}' is not registered for admin authoring.");

        var settings = options.Value;
        if (!settings.TryGetConfiguredProvider(model.Provider, out var providerSettings))
            throw new InvalidOperationException(
                $"AdminAuthoring provider '{model.Provider}' is not enabled or has no API key.");

        return await agent.ReplyAsync(
            sessionId,
            history,
            message,
            model,
            providerSettings.ApiKey,
            settings.TimeoutSeconds,
            cancellationToken);
    }
}
