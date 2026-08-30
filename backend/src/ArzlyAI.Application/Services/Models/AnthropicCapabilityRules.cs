namespace ArzlyAI.Application.Services.Models;

internal static class AnthropicCapabilityRules
{
    public static bool IsUsable(string model) =>
        model.StartsWith("claude-", StringComparison.OrdinalIgnoreCase);

    public static bool SupportsTemperature(string model) => IsUsable(model);

    public static bool SupportsWebSearch(string model) =>
        IsUsable(model) &&
        (model.Contains("claude-sonnet-4", StringComparison.OrdinalIgnoreCase) ||
         model.Contains("claude-opus-4", StringComparison.OrdinalIgnoreCase) ||
         model.Contains("claude-3-5-sonnet", StringComparison.OrdinalIgnoreCase) ||
         model.Contains("claude-3-7-sonnet", StringComparison.OrdinalIgnoreCase));
}
