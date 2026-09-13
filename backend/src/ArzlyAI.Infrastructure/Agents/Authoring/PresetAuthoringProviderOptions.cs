namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class PresetAuthoringProviderOptions
{
    public bool Enabled { get; init; }
    public string ApiKey { get; init; } = string.Empty;
}
