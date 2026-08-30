namespace ArzlyAI.Application.Constants;

public static class AiProviderKeys
{
    public const string OpenAi = "openai";
    public const string Anthropic = "anthropic";
    public const string Gemini = "gemini";
    public const string DeepSeek = "deepseek";

    public static readonly IReadOnlyList<string> All =
    [
        OpenAi,
        Anthropic,
        Gemini,
        DeepSeek
    ];

    public static bool IsSupported(string provider) =>
        All.Any(key => key.Equals(provider, StringComparison.OrdinalIgnoreCase));

    public static string CredentialKey(string provider) =>
        $"{provider.ToLowerInvariant()}.apiKey";
}
