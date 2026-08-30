namespace ArzlyAI.Application.Services.Models;

internal static class DeepSeekCapabilityRules
{
    public static bool IsUsable(string model) =>
        model.StartsWith("deepseek-", StringComparison.OrdinalIgnoreCase);

    public static bool SupportsTemperature(string model) => IsUsable(model);

    public static bool SupportsWebSearch(string model) =>
        model.Equals("deepseek-v4-flash", StringComparison.OrdinalIgnoreCase) ||
        model.Equals("deepseek-v4-pro", StringComparison.OrdinalIgnoreCase) ||
        model.StartsWith("deepseek-v4-flash-", StringComparison.OrdinalIgnoreCase);
}
