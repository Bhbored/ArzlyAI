using System.Globalization;
using System.Text.Json;

namespace ArzlyAI.Infrastructure.Integrations.Google;

internal static class GoogleIntegrationValues
{
    public static string Required(IReadOnlyDictionary<string, string> values, string key) =>
        values.TryGetValue(key, out var value) && !string.IsNullOrWhiteSpace(value)
            ? value
            : throw new ArgumentException($"Required value '{key}' is missing.");

    public static IReadOnlyList<IReadOnlyList<string>> Rows(
        IReadOnlyDictionary<string, string> inputs,
        string key)
    {
        var rows = JsonSerializer.Deserialize<List<List<string>>>(Required(inputs, key))
            ?? throw new ArgumentException($"Value '{key}' must contain a JSON row array.");
        if (rows.Count == 0)
            throw new ArgumentException($"Value '{key}' must contain at least one row.");
        return rows.Select(row => (IReadOnlyList<string>)row).ToList();
    }

    public static int MaximumRows(IReadOnlyDictionary<string, string> inputs)
    {
        if (!inputs.TryGetValue("maximumRows", out var raw) || string.IsNullOrWhiteSpace(raw))
            return 500;
        if (!int.TryParse(raw, NumberStyles.None, CultureInfo.InvariantCulture, out var value) ||
            value is < 1 or > 1000)
            throw new ArgumentException("maximumRows must be between 1 and 1000.");
        return value;
    }
}
