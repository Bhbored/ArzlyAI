namespace ArzlyAI.Application.Services.Models;

public sealed class OpenAiModelCapabilityPolicy : IModelCapabilityPolicy
{
    private static readonly string[] ExcludedFragments =
    [
        "audio", "realtime", "transcribe", "tts", "image", "search",
        "moderation", "embedding", "whisper", "sora", "dall-e", "computer-use"
    ];

    public bool IsUsable(string provider, string model) =>
        provider.Equals("openai", StringComparison.OrdinalIgnoreCase) &&
        (model.StartsWith("gpt-", StringComparison.OrdinalIgnoreCase) ||
         IsReasoningModel(model)) &&
        ExcludedFragments.All(fragment =>
            !model.Contains(fragment, StringComparison.OrdinalIgnoreCase));

    public bool SupportsTemperature(string provider, string model)
    {
        if (!IsUsable(provider, model) || IsReasoningModel(model)) return false;

        return model.StartsWith("gpt-4", StringComparison.OrdinalIgnoreCase) ||
               model.StartsWith("gpt-3.5", StringComparison.OrdinalIgnoreCase);
    }

    public bool SupportsWebSearch(string provider, string model) =>
        IsUsable(provider, model) &&
        (model.StartsWith("gpt-4", StringComparison.OrdinalIgnoreCase) ||
         model.StartsWith("gpt-5", StringComparison.OrdinalIgnoreCase) ||
         IsReasoningModel(model));

    private static bool IsReasoningModel(string model) =>
        model.Length >= 2 &&
        model[0] == 'o' &&
        char.IsDigit(model[1]);
}
