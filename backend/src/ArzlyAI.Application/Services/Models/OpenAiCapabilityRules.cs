namespace ArzlyAI.Application.Services.Models;

internal static class OpenAiCapabilityRules
{
    private static readonly string[] ExcludedFragments =
    [
        "audio", "realtime", "transcribe", "tts", "image", "search",
        "moderation", "embedding", "whisper", "sora", "dall-e", "computer-use"
    ];

    public static bool IsUsable(string model) =>
        (model.StartsWith("gpt-", StringComparison.OrdinalIgnoreCase) ||
         IsReasoningModel(model)) &&
        ExcludedFragments.All(fragment =>
            !model.Contains(fragment, StringComparison.OrdinalIgnoreCase));

    public static bool SupportsTemperature(string model)
    {
        if (!IsUsable(model) || IsReasoningModel(model)) return false;

        return model.StartsWith("gpt-4", StringComparison.OrdinalIgnoreCase) ||
               model.StartsWith("gpt-3.5", StringComparison.OrdinalIgnoreCase);
    }

    public static bool SupportsWebSearch(string model) =>
        IsUsable(model) &&
        (model.StartsWith("gpt-4", StringComparison.OrdinalIgnoreCase) ||
         model.StartsWith("gpt-5", StringComparison.OrdinalIgnoreCase) ||
         IsReasoningModel(model));

    private static bool IsReasoningModel(string model) =>
        model.Length >= 2 &&
        model[0] == 'o' &&
        char.IsDigit(model[1]);
}
