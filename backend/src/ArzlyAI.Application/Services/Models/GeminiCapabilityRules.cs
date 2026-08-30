namespace ArzlyAI.Application.Services.Models;

public static class GeminiCapabilityRules
{
    public static bool IsUsable(string model)
    {
        var normalized = Normalize(model);
        return normalized.StartsWith("gemini-", StringComparison.OrdinalIgnoreCase) &&
               !normalized.Contains("embedding", StringComparison.OrdinalIgnoreCase) &&
               !normalized.Contains("aqa", StringComparison.OrdinalIgnoreCase) &&
               !normalized.Contains("imagen", StringComparison.OrdinalIgnoreCase);
    }

    public static bool SupportsTemperature(string model) => IsUsable(model);

    public static bool SupportsWebSearch(string model)
    {
        var normalized = Normalize(model);
        return IsUsable(model) &&
               (normalized.Contains("gemini-2", StringComparison.OrdinalIgnoreCase) ||
                normalized.Contains("gemini-1.5", StringComparison.OrdinalIgnoreCase));
    }

    public static string Normalize(string model) =>
        model.StartsWith("models/", StringComparison.OrdinalIgnoreCase)
            ? model["models/".Length..]
            : model;
}
