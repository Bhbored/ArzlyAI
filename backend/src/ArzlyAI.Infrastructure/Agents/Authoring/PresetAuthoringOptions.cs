namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class PresetAuthoringOptions
{
    public const string SectionName = "AdminAuthoring";
    public string DefaultProvider { get; init; } = "openai";
    public string DefaultModel { get; init; } = "gpt-5-mini";
    public int TimeoutSeconds { get; init; } = 300;
    public Dictionary<string, PresetAuthoringProviderOptions> Providers { get; init; } =
        new Dictionary<string, PresetAuthoringProviderOptions>(StringComparer.OrdinalIgnoreCase);

    public bool TryGetConfiguredProvider(string provider, out PresetAuthoringProviderOptions settings)
    {
        if (Providers.TryGetValue(provider, out var configured) &&
            configured.Enabled && !string.IsNullOrWhiteSpace(configured.ApiKey))
        {
            settings = configured;
            return true;
        }

        settings = new PresetAuthoringProviderOptions();
        return false;
    }
}
