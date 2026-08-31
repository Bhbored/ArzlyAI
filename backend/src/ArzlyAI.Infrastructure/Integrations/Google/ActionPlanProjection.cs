using System.Globalization;
using System.Text.Json;
using ArzlyAI.Application.Services.Workflows.Rendering;

namespace ArzlyAI.Infrastructure.Integrations.Google;

public sealed record ActionPlanTask(string Title, string? Notes, IReadOnlyList<string> Subtasks);

public sealed record ActionPlanEvent(
    string Title,
    string Description,
    DateTimeOffset Start,
    DateTimeOffset End);

public static class ActionPlanProjection
{
    public static string ToHtml(string reportJson)
    {
        using var document = Parse(reportJson);
        return new ArzlyReportHtmlRenderer().Render(document.RootElement);
    }

    public static IReadOnlyList<ActionPlanTask> ToTasks(string reportJson)
    {
        using var document = Parse(reportJson);
        var tasks = new List<ActionPlanTask>();
        foreach (var block in Blocks(document.RootElement))
        {
            var type = Text(block, "type");
            if (type is not ("quickWins" or "projects" or "priorityCallout" or "nextSteps"))
                continue;
            foreach (var item in Items(Data(block)))
            {
                var title = Text(item, "label");
                if (string.IsNullOrWhiteSpace(title)) continue;
                var detail = Text(item, "detail");
                var subtasks = type == "projects"
                    ? detail.Split('\n', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
                        .Where(line => !string.IsNullOrWhiteSpace(line))
                        .ToList()
                    : [];
                tasks.Add(new ActionPlanTask(
                    title,
                    string.IsNullOrWhiteSpace(detail) ? Text(item, "value") : detail,
                    subtasks));
            }
        }
        return tasks;
    }

    public static IReadOnlyList<ActionPlanEvent> ToEvents(
        string reportJson,
        string asOfDate,
        string workingHoursStart,
        string workingHoursEnd)
    {
        using var document = Parse(reportJson);
        var anchor = ParseDate(asOfDate);
        var dayStart = ParseTime(workingHoursStart);
        var dayEnd = ParseTime(workingHoursEnd);
        var events = new List<ActionPlanEvent>();
        var slotStart = new DateTimeOffset(anchor.Date.Add(dayStart), TimeSpan.Zero);
        foreach (var block in Blocks(document.RootElement))
        {
            if (Text(block, "type") != "schedule") continue;
            foreach (var item in Items(Data(block)))
            {
                var title = Text(item, "label");
                if (string.IsNullOrWhiteSpace(title)) continue;
                var value = Text(item, "value");
                var detail = Text(item, "detail");
                var duration = ParseDuration(value);
                var start = TryParseEventStart(value, anchor) ?? slotStart;
                var end = start.Add(duration);
                if (end.TimeOfDay > dayEnd && start.Date == anchor.Date)
                    end = new DateTimeOffset(anchor.Date.Add(dayEnd), start.Offset);
                events.Add(new ActionPlanEvent(title, detail, start, end));
                slotStart = end.AddMinutes(15);
                if (slotStart.TimeOfDay >= dayEnd)
                    slotStart = new DateTimeOffset(anchor.Date.AddDays(1).Add(dayStart), start.Offset);
            }
        }
        return events;
    }

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
            throw new ArgumentException("Action plan delivery requires an arzly.report version 4 document.");
        }
        return document;
    }

    private static IEnumerable<JsonElement> Blocks(JsonElement document) =>
        document.TryGetProperty("blocks", out var blocks) && blocks.ValueKind == JsonValueKind.Array
            ? blocks.EnumerateArray()
            : [];

    private static JsonElement Data(JsonElement block) =>
        block.TryGetProperty("data", out var data) && data.ValueKind == JsonValueKind.Object
            ? data
            : default;

    private static IEnumerable<JsonElement> Items(JsonElement data) =>
        data.ValueKind == JsonValueKind.Object &&
        data.TryGetProperty("items", out var items) &&
        items.ValueKind == JsonValueKind.Array
            ? items.EnumerateArray()
            : [];

    private static string Text(JsonElement element, string property) =>
        element.ValueKind == JsonValueKind.Object &&
        element.TryGetProperty(property, out var value) &&
        value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? string.Empty
            : string.Empty;

    private static DateTime ParseDate(string value) =>
        DateTime.TryParse(
            value,
            CultureInfo.InvariantCulture,
            DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal,
            out var parsed)
            ? parsed
            : throw new ArgumentException("asOfDate must be a valid ISO date.");

    private static TimeSpan ParseTime(string value)
    {
        if (TimeSpan.TryParse(value, CultureInfo.InvariantCulture, out var parsed))
            return parsed;
        throw new ArgumentException("Working hours must use HH:mm format.");
    }

    private static TimeSpan ParseDuration(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return TimeSpan.FromMinutes(30);
        var normalized = value.ToLowerInvariant();
        if (normalized.Contains("hour", StringComparison.Ordinal))
        {
            var digits = new string(normalized.Where(char.IsDigit).ToArray());
            if (int.TryParse(digits, NumberStyles.None, CultureInfo.InvariantCulture, out var hours))
                return TimeSpan.FromHours(Math.Max(hours, 1));
        }
        if (normalized.Contains("min", StringComparison.Ordinal))
        {
            var digits = new string(normalized.Where(char.IsDigit).ToArray());
            if (int.TryParse(digits, NumberStyles.None, CultureInfo.InvariantCulture, out var minutes))
                return TimeSpan.FromMinutes(Math.Max(minutes, 5));
        }
        return TimeSpan.FromMinutes(30);
    }

    private static DateTimeOffset? TryParseEventStart(string value, DateTime anchor)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;
        if (DateTimeOffset.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.AssumeLocal, out var parsed))
            return parsed;
        var timeOnly = ParseTime(value);
        return new DateTimeOffset(anchor.Date.Add(timeOnly), TimeSpan.Zero);
    }
}
