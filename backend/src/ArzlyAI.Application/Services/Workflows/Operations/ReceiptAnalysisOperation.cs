using System.Globalization;
using System.Text.Json;

namespace ArzlyAI.Application.Services.Workflows.Operations;

public sealed class ReceiptAnalysisOperation : IWorkflowOperation
{
    public const string OperationKey = "receipt.analyze";
    public const int MaximumReceiptRows = 1000;
    private static readonly string[] Modes =
    [
        "monthly-spending",
        "weekly-budget",
        "quarterly-tax",
        "yearly-review",
        "category-dive",
        "anomaly-detector",
        "savings-tracker"
    ];

    public string Key => OperationKey;

    public Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var mode = Required(inputs, "analysisMode");
        if (!Modes.Contains(mode, StringComparer.Ordinal))
            throw new ArgumentException($"Unsupported receipt analysis mode '{mode}'.");

        var rows = JsonSerializer.Deserialize<List<List<string>>>(Required(inputs, "rowsJson"))
            ?? throw new ArgumentException("Receipt rows must be a JSON array.");
        if (rows.Count < 2) throw new ArgumentException("Receipt rows must include a header and data.");
        if (rows.Count - 1 > MaximumReceiptRows)
            throw new ArgumentException($"Receipt input exceeds the {MaximumReceiptRows}-row limit.");

        var mapping = JsonSerializer.Deserialize<Dictionary<string, string>>(
            Required(inputs, "columnMappingJson"))
            ?? throw new ArgumentException("Column mapping must be a JSON object.");
        if (mapping.Count != 4 ||
            mapping.Keys.Any(key => key is not ("date" or "amount" or "category" or "merchant")) ||
            mapping.Values.Distinct(StringComparer.Ordinal).Count() != 4)
            throw new ArgumentException(
                "Column mapping must contain four distinct date, amount, category, and merchant columns.");
        var headers = rows[0];
        var indexes = RequiredColumns(mapping).ToDictionary(
            pair => pair.Key,
            pair =>
            {
                var matches = headers
                    .Select((header, index) => (header, index))
                    .Where(item => item.header.Equals(pair.Value, StringComparison.Ordinal))
                    .Select(item => item.index)
                    .ToList();
                return matches.Count == 1
                    ? matches[0]
                    : throw new ArgumentException(
                        $"Mapped column '{pair.Value}' for '{pair.Key}' must occur exactly once.");
            },
            StringComparer.Ordinal);

        var receipts = rows.Skip(1).Select((row, index) =>
            ParseRow(row, index + 2, indexes)).ToList();
        var asOfDate = ParseDate(Required(inputs, "asOfDate"), "asOfDate");
        var period = PeriodFor(mode, asOfDate);
        var filtered = receipts
            .Where(receipt => receipt.Date >= period.Start &&
                              receipt.Date <= period.End &&
                              receipt.Date <= asOfDate)
            .OrderBy(receipt => receipt.Date)
            .ThenBy(receipt => receipt.Merchant, StringComparer.Ordinal)
            .ThenBy(receipt => receipt.Category, StringComparer.Ordinal)
            .ThenBy(receipt => receipt.Amount)
            .ToList();

        if (mode == "category-dive")
        {
            var category = Required(inputs, "category");
            filtered = filtered.Where(receipt =>
                    receipt.Category.Equals(category, StringComparison.OrdinalIgnoreCase))
                .ToList();
        }

        var total = filtered.Sum(receipt => receipt.Amount);
        var categoryTotals = Group(filtered, receipt => receipt.Category);
        var merchantTotals = Group(filtered, receipt => receipt.Merchant);
        var result = new Dictionary<string, object?>
        {
            ["analysisMode"] = mode,
            ["currencyCode"] = Required(inputs, "currencyCode").ToUpperInvariant(),
            ["periodStart"] = period.Start.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
            ["periodEnd"] = period.End.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
            ["receiptCount"] = filtered.Count,
            ["total"] = total,
            ["average"] = filtered.Count == 0 ? 0 : Round(total / filtered.Count),
            ["categories"] = categoryTotals,
            ["merchants"] = merchantTotals
        };
        AddModeAnalysis(result, mode, filtered, total, inputs, period);
        return Task.FromResult(JsonSerializer.Serialize(result));
    }

    private static Dictionary<string, string> RequiredColumns(IReadOnlyDictionary<string, string> mapping)
    {
        var result = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (var key in new[] { "date", "amount", "category", "merchant" })
            result[key] = Required(mapping, key, "Column mapping");
        return result;
    }

    private static Receipt ParseRow(
        IReadOnlyList<string> row,
        int rowNumber,
        IReadOnlyDictionary<string, int> indexes)
    {
        string Cell(string key)
        {
            var index = indexes[key];
            if (index >= row.Count || string.IsNullOrWhiteSpace(row[index]))
                throw new ArgumentException($"Receipt row {rowNumber} has no '{key}' value.");
            return row[index].Trim();
        }

        var dateText = Cell("date");
        var amountText = Cell("amount");
        if (!DateOnly.TryParseExact(dateText, "yyyy-MM-dd", CultureInfo.InvariantCulture,
                DateTimeStyles.None, out var date))
            throw new ArgumentException($"Receipt row {rowNumber} has an invalid date.");
        if (!decimal.TryParse(amountText, NumberStyles.AllowDecimalPoint,
                CultureInfo.InvariantCulture, out var amount) || amount < 0)
            throw new ArgumentException($"Receipt row {rowNumber} has an invalid amount.");
        return new Receipt(date, amount, Cell("category"), Cell("merchant"));
    }

    private static (DateOnly Start, DateOnly End) PeriodFor(string mode, DateOnly asOf)
    {
        if (mode == "weekly-budget")
        {
            var offset = ((int)asOf.DayOfWeek + 6) % 7;
            var start = asOf.AddDays(-offset);
            return (start, start.AddDays(6));
        }
        if (mode == "quarterly-tax")
        {
            var month = ((asOf.Month - 1) / 3) * 3 + 1;
            var start = new DateOnly(asOf.Year, month, 1);
            return (start, start.AddMonths(3).AddDays(-1));
        }
        if (mode == "yearly-review")
            return (new DateOnly(asOf.Year, 1, 1), new DateOnly(asOf.Year, 12, 31));

        var monthStart = new DateOnly(asOf.Year, asOf.Month, 1);
        return (monthStart, monthStart.AddMonths(1).AddDays(-1));
    }

    private static void AddModeAnalysis(
        IDictionary<string, object?> result,
        string mode,
        IReadOnlyList<Receipt> receipts,
        decimal total,
        IReadOnlyDictionary<string, string> inputs,
        (DateOnly Start, DateOnly End) period)
    {
        switch (mode)
        {
            case "weekly-budget":
            case "savings-tracker":
                var budget = PositiveDecimal(inputs, "budget");
                result["budget"] = budget;
                result["remaining"] = Round(budget - total);
                result["percentUsed"] = Round(total / budget * 100);
                if (mode == "savings-tracker")
                    result["potentialSavings"] = Math.Max(0, Round(budget - total));
                break;
            case "quarterly-tax":
                var taxRate = OptionalDecimal(inputs, "taxRate", 0);
                if (taxRate is < 0 or > 1)
                    throw new ArgumentException("taxRate must be between 0 and 1.");
                result["taxRate"] = taxRate;
                result["estimatedTax"] = Round(total * taxRate);
                break;
            case "yearly-review":
                result["monthlyTotals"] = Enumerable.Range(0, 12).Select(offset =>
                {
                    var month = period.Start.AddMonths(offset);
                    return new
                    {
                        month = month.ToString("yyyy-MM", CultureInfo.InvariantCulture),
                        total = receipts.Where(item => item.Date.Year == month.Year &&
                                                       item.Date.Month == month.Month)
                            .Sum(item => item.Amount)
                    };
                }).ToList();
                break;
            case "category-dive":
                result["category"] = Required(inputs, "category");
                break;
            case "anomaly-detector":
                var mean = receipts.Count == 0 ? 0 : receipts.Average(item => item.Amount);
                var variance = receipts.Count == 0
                    ? 0
                    : receipts.Average(item => (item.Amount - mean) * (item.Amount - mean));
                var threshold = mean + 2 * (decimal)Math.Sqrt((double)variance);
                result["anomalyThreshold"] = Round(threshold);
                result["anomalies"] = receipts.Where(item => item.Amount > threshold)
                    .Select(item => new
                    {
                        date = item.Date.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
                        item.Merchant,
                        item.Category,
                        item.Amount
                    }).ToList();
                break;
        }
    }

    private static IReadOnlyList<object> Group(
        IEnumerable<Receipt> receipts,
        Func<Receipt, string> selector) =>
        receipts.GroupBy(selector, StringComparer.OrdinalIgnoreCase)
            .Select(group => new
            {
                name = group.Key,
                total = group.Sum(item => item.Amount),
                count = group.Count()
            })
            .OrderByDescending(item => item.total)
            .ThenBy(item => item.name, StringComparer.Ordinal)
            .Cast<object>()
            .ToList();

    private static DateOnly ParseDate(string value, string key) =>
        DateOnly.TryParseExact(value, "yyyy-MM-dd", CultureInfo.InvariantCulture,
            DateTimeStyles.None, out var date)
            ? date
            : throw new ArgumentException($"{key} must use yyyy-MM-dd.");

    private static decimal PositiveDecimal(IReadOnlyDictionary<string, string> values, string key)
    {
        var value = OptionalDecimal(values, key, -1);
        return value > 0 ? value : throw new ArgumentException($"{key} must be greater than zero.");
    }

    private static decimal OptionalDecimal(
        IReadOnlyDictionary<string, string> values,
        string key,
        decimal fallback) =>
        values.TryGetValue(key, out var text) && !string.IsNullOrWhiteSpace(text)
            ? decimal.TryParse(text, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture,
                out var value)
                ? value
                : throw new ArgumentException($"{key} must be a decimal.")
            : fallback;

    private static string Required(IReadOnlyDictionary<string, string> values, string key) =>
        Required(values, key, "Receipt analysis");

    private static string Required(
        IReadOnlyDictionary<string, string> values,
        string key,
        string subject) =>
        values.TryGetValue(key, out var value) && !string.IsNullOrWhiteSpace(value)
            ? value.Trim()
            : throw new ArgumentException($"{subject} requires '{key}'.");

    private static decimal Round(decimal value) =>
        Math.Round(value, 2, MidpointRounding.AwayFromZero);

    private sealed record Receipt(DateOnly Date, decimal Amount, string Category, string Merchant);
}
