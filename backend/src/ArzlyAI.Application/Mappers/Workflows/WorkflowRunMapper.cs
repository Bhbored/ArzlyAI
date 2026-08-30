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
        try
        {
            using var document = JsonDocument.Parse(content);
            if (!MatchesResultContract(document.RootElement, run.ResultContractKey, run.ResultContractVersion))
            {
                if (run.FinalResponse is not null)
                    throw new InvalidOperationException(
                        $"Workflow '{run.PresetKey}' produced a result that does not match " +
                        $"'{run.ResultContractKey}' version {run.ResultContractVersion}.");
                return null;
            }
            return document.RootElement.Clone();
        }
        catch (JsonException exception)
        {
            throw new InvalidOperationException(
                $"Workflow '{run.PresetKey}' produced an invalid result document.", exception);
        }
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
