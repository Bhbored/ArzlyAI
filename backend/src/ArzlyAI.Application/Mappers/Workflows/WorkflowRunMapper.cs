using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Services.Workflows.Rendering;
using ArzlyAI.Domain.Enums;
using System.Text.Json;

namespace ArzlyAI.Application.Mappers.Workflows;

public sealed class WorkflowRunMapper(
    IEnumerable<IWorkflowResultRenderer>? resultRenderers = null) : IWorkflowRunMapper
{
    private readonly IReadOnlyList<IWorkflowResultRenderer> renderers = resultRenderers?.ToList() ?? [];

    public WorkflowRunResponse ToResponse(WorkflowRun run)
    {
        var document = ParseResultDocument(run);
        return new WorkflowRunResponse(
            run.Id,
            run.PresetKey,
            run.Status.ToString(),
            run.Nodes.Select(node => new WorkflowNodeRunResponse(
                node.NodeId,
                node.NodeKey,
                node.DisplayName,
                node.Type.ToString(),
                node.Status.ToString(),
                node.Status == WorkflowNodeStatus.Running,
                node.Output,
                node.Error,
                node.EffectiveProvider,
                node.EffectiveModel,
                node.EffectiveTemperature)).ToList(),
            run.OriginalContent is null
                ? null
                : new ApprovalSnapshotResponse(
                    run.OriginalContent,
                    run.CurrentContent ?? run.OriginalContent,
                    run.CurrentContent != run.OriginalContent),
            run.FinalResponse,
            document,
            RenderResult(run, document));
    }

    private RenderedWorkflowResultResponse? RenderResult(WorkflowRun run, JsonElement? document)
    {
        if (document is null || run.ResultContractKey is null || run.ResultContractVersion is null) return null;
        var renderer = renderers.SingleOrDefault(candidate =>
            candidate.CanRender(run.ResultContractKey, run.ResultContractVersion.Value));
        return renderer is null
            ? null
            : new RenderedWorkflowResultResponse("text/html", renderer.Render(document.Value));
    }

    private static JsonElement? ParseResultDocument(WorkflowRun run)
    {
        if (run.ResultContractKey is null) return null;
        var content = !string.IsNullOrWhiteSpace(run.FinalResponse)
            ? run.FinalResponse
            : run.CurrentContent;
        if (string.IsNullOrWhiteSpace(content)) return null;
        if (!TryParseJsonRoot(content, out var document) || document is null)
        {
            if (run.FinalResponse is null) return null;
            throw new InvalidOperationException(
                $"Workflow '{run.PresetKey}' produced an invalid result document.");
        }

        using (document)
        {
            var root = document.RootElement;
            if (!MatchesResultContract(root, run.ResultContractKey, run.ResultContractVersion))
            {
                var normalized = TryNormalizeReportDocument(
                    root,
                    run.ResultContractKey,
                    run.ResultContractVersion);
                if (normalized is null)
                {
                    if (run.FinalResponse is not null)
                        throw new InvalidOperationException(
                            $"Workflow '{run.PresetKey}' produced a result that does not match " +
                            $"'{run.ResultContractKey}' version {run.ResultContractVersion}.");
                    return null;
                }

                root = normalized.Value;
            }

            return root.Clone();
        }
    }

    private static bool TryParseJsonRoot(string content, out JsonDocument? document)
    {
        try
        {
            document = JsonDocument.Parse(content);
            return true;
        }
        catch (JsonException)
        {
            var extracted = ExtractJsonObject(content);
            if (extracted is null)
            {
                document = null;
                return false;
            }

            try
            {
                document = JsonDocument.Parse(extracted);
                return true;
            }
            catch (JsonException)
            {
                document = null;
                return false;
            }
        }
    }

    private static string? ExtractJsonObject(string content)
    {
        var start = content.IndexOf('{');
        var end = content.LastIndexOf('}');
        return start < 0 || end <= start ? null : content[start..(end + 1)];
    }

    private static JsonElement? TryNormalizeReportDocument(
        JsonElement document,
        string contractKey,
        int? contractVersion)
    {
        if (document.ValueKind != JsonValueKind.Object) return null;
        if (MatchesResultContract(document, contractKey, contractVersion)) return document.Clone();

        var hasBlocks = document.TryGetProperty("blocks", out var blocks) &&
                        blocks.ValueKind == JsonValueKind.Array &&
                        blocks.GetArrayLength() > 0;
        var hasSources = document.TryGetProperty("sources", out var sources) &&
                         sources.ValueKind == JsonValueKind.Array &&
                         sources.GetArrayLength() > 0;
        if (!hasBlocks && !hasSources) return null;

        var hasKind = document.TryGetProperty("kind", out var kind) &&
                      kind.GetString() == "purchaseDecision";
        var hasVersion = document.TryGetProperty("version", out var version) &&
                         version.TryGetInt32(out var versionValue) &&
                         (contractVersion is null || versionValue == contractVersion);
        if (!hasKind && !hasVersion) return null;

        using var stream = new MemoryStream();
        using (var writer = new Utf8JsonWriter(stream))
        {
            writer.WriteStartObject();
            writer.WriteString("schema", contractKey);
            if (contractVersion is int contractVersionValue)
                writer.WriteNumber("version", contractVersionValue);
            var wroteKind = false;
            var wroteBlocks = hasBlocks;
            foreach (var property in document.EnumerateObject())
            {
                if (property.NameEquals("schema")) continue;
                if (property.NameEquals("version") && contractVersion is int) continue;
                if (property.NameEquals("kind"))
                {
                    wroteKind = true;
                    property.WriteTo(writer);
                    continue;
                }
                if (property.NameEquals("blocks"))
                {
                    if (hasBlocks) property.WriteTo(writer);
                    continue;
                }
                property.WriteTo(writer);
            }
            if (!wroteKind) writer.WriteString("kind", "purchaseDecision");
            if (!wroteBlocks && hasSources)
            {
                writer.WritePropertyName("blocks");
                writer.WriteStartArray();
                writer.WriteStartObject();
                writer.WriteString("type", "recommendation");
                writer.WriteString("title", document.TryGetProperty("title", out var title)
                    ? title.GetString() ?? "Options"
                    : "Options");
                writer.WritePropertyName("data");
                writer.WriteStartObject();
                writer.WriteString("text", document.TryGetProperty("summary", out var summary)
                    ? summary.GetString() ?? string.Empty
                    : string.Empty);
                writer.WritePropertyName("items");
                writer.WriteStartArray();
                foreach (var source in sources.EnumerateArray())
                {
                    if (source.ValueKind != JsonValueKind.Object) continue;
                    writer.WriteStartObject();
                    writer.WriteString("label", source.TryGetProperty("title", out var sourceTitle)
                        ? sourceTitle.GetString() ?? string.Empty
                        : string.Empty);
                    writer.WriteString("value", string.Empty);
                    writer.WriteString("detail", source.TryGetProperty("publisher", out var publisher)
                        ? publisher.GetString() ?? string.Empty
                        : string.Empty);
                    if (source.TryGetProperty("url", out var url) &&
                        url.ValueKind == JsonValueKind.String)
                        writer.WriteString("url", url.GetString());
                    writer.WritePropertyName("actions");
                    writer.WriteStartArray();
                    writer.WriteEndArray();
                    writer.WriteEndObject();
                }
                writer.WriteEndArray();
                writer.WriteEndObject();
                writer.WriteEndObject();
                writer.WriteEndArray();
            }
            writer.WriteEndObject();
        }

        stream.Position = 0;
        using var normalized = JsonDocument.Parse(stream);
        var root = normalized.RootElement;
        return MatchesResultContract(root, contractKey, contractVersion) ? root.Clone() : null;
    }

    private static bool MatchesResultContract(
        JsonElement document,
        string contractKey,
        int? contractVersion) =>
        document.ValueKind == JsonValueKind.Object &&
        document.TryGetProperty("schema", out var schema) &&
        schema.ValueKind == JsonValueKind.String &&
        schema.GetString() == contractKey &&
        (contractVersion is null ||
         document.TryGetProperty("version", out var version) &&
         version.TryGetInt32(out var value) &&
         value == contractVersion);
}
