namespace ArzlyAI.Application.Services.Models;

internal static class DeepSeekCapabilityRules
{
    public static bool IsUsable(string model) =>
        model.StartsWith("deepseek-", StringComparison.OrdinalIgnoreCase);

    public static bool SupportsTemperature(string model) => IsUsable(model);

    public static bool SupportsWebSearch(string _) => false;
}
