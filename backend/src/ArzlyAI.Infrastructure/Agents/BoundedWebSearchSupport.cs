using System.Text.Json;

namespace ArzlyAI.Infrastructure.Agents;

internal static class BoundedWebSearchSupport
{
    public const int MaximumSearchPasses = 3;
    public const int MaximumEvidenceCharactersPerPass = 12_000;

    public static int SearchPassCount(int maxIterations) =>
        Math.Clamp(maxIterations, 1, MaximumSearchPasses);

    public static string BuildFollowUpResearchInput(
        string originalInput,
        IReadOnlyList<string> evidence,
        int passNumber,
        int totalPasses) =>
        $"Original request:\n{originalInput}\n\n" +
        $"Research gathered before pass {passNumber} of {totalPasses}:\n" +
        $"{BuildEvidenceDocument(evidence)}\n\n" +
        "Continue the web research instead of merely summarizing it. Use different search queries and " +
        "alternative credible domains to fill missing candidates, facts, prices, availability, direct " +
        "URLs, images, and specifications. Preserve useful verified findings from earlier passes, " +
        "clearly mark unresolved gaps, and return the complete response required by the system " +
        "instructions. Do not invent facts.";

    public static string BuildFormattingInput(string originalInput, IReadOnlyList<string> evidence) =>
        $"Original request:\n{originalInput}\n\n" +
        "Accumulated web research:\n" +
        $"{BuildEvidenceDocument(evidence)}\n\n" +
        "Convert only the supplied research into the required JSON document. Preserve distinct supported " +
        "candidates and findings even when optional details could not all be verified. Represent " +
        "verification gaps using the schema's empty lists, nulls, and explanatory text. Do not replace " +
        "supported candidates with a no-result response solely because optional details are missing. " +
        "Do not perform another search or invent facts.";

    public static string BuildEvidenceDocument(IReadOnlyList<string> evidence) =>
        string.Join(
            "\n\n",
            evidence.Select((item, index) => $"Research pass {index + 1}:\n{item}"));

    public static string TruncateEvidence(string value) =>
        value.Length <= MaximumEvidenceCharactersPerPass
            ? value
            : value[..MaximumEvidenceCharactersPerPass];

    public static bool TryExtractJsonObject(string content, out string json)
    {
        var trimmed = content.Trim();
        if (TryParseJson(trimmed))
        {
            json = trimmed;
            return true;
        }

        var start = trimmed.IndexOf('{');
        var end = trimmed.LastIndexOf('}');
        if (start >= 0 && end > start)
        {
            var candidate = trimmed[start..(end + 1)];
            if (TryParseJson(candidate))
            {
                json = candidate;
                return true;
            }
        }

        json = string.Empty;
        return false;
    }

    private static bool TryParseJson(string content)
    {
        try
        {
            using var _ = JsonDocument.Parse(content);
            return true;
        }
        catch (JsonException)
        {
            return false;
        }
    }
}
