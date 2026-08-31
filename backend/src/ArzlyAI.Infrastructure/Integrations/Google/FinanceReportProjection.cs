using System.Text.Json;
using ArzlyAI.Application.Services.Workflows.Rendering;

namespace ArzlyAI.Infrastructure.Integrations.Google;

internal static class FinanceReportProjection
{
    public static IReadOnlyList<IReadOnlyList<string>> ToRows(string reportJson)
    {
        using var document = Parse(reportJson);
        var rows = new List<IReadOnlyList<string>>
        {
            new[] { "Receipt report", Text(document.RootElement, "title") },
            new[] { "Summary", Text(document.RootElement, "summary") }
        };
        if (!document.RootElement.TryGetProperty("blocks", out var blocks) ||
            blocks.ValueKind != JsonValueKind.Array)
            return rows;

        foreach (var block in blocks.EnumerateArray())
        {
            var title = Text(block, "title");
            if (block.TryGetProperty("data", out var data))
            {
                var text = Text(data, "text");
                if (!string.IsNullOrWhiteSpace(text)) rows.Add(new[] { title, text });
                if (data.TryGetProperty("items", out var items) &&
                    items.ValueKind == JsonValueKind.Array)
                {
                    foreach (var item in items.EnumerateArray())
                        rows.Add(new[]
                        {
                            title,
                            Text(item, "label"),
                            Text(item, "value"),
                            Text(item, "detail")
                        });
                }
            }
        }
        return rows;
    }

    public static string ToHtml(string reportJson) => ActionPlanProjection.ToHtml(reportJson);

    private static JsonDocument Parse(string reportJson)
    {
        var document = JsonDocument.Parse(reportJson);
        var root = document.RootElement;
        if (root.ValueKind != JsonValueKind.Object ||
            !Text(root, "schema").Equals("arzly.report", StringComparison.Ordinal) ||
            !root.TryGetProperty("version", out var version) ||
            version.GetInt32() != 4)
        {
            document.Dispose();
            throw new ArgumentException("Finance delivery requires an arzly.report version 4 document.");
        }
        return document;
    }

    private static string Text(JsonElement element, string property) =>
        element.TryGetProperty(property, out var value) && value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? string.Empty
            : string.Empty;
}
