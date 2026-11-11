using System.Text.Json;
using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public static class AuthoringDraftPreview
{
    public static AuthoringPreviewResponse Build(
        PresetDraftDocument draft, int revision, PresetValidationResult validation, JsonElement inputs)
    {
        if (inputs.ValueKind != JsonValueKind.Object) throw new ArgumentException("Sample inputs must be a JSON object.");
        var errors = validation.Errors.ToList();
        try
        {
            using var schema = JsonDocument.Parse(draft.InputSchemaJson);
            if (schema.RootElement.ValueKind == JsonValueKind.Object)
            {
                if (schema.RootElement.TryGetProperty("required", out var required) && required.ValueKind == JsonValueKind.Array)
                    foreach (var field in required.EnumerateArray())
                        if (field.ValueKind == JsonValueKind.String && !inputs.TryGetProperty(field.GetString()!, out _))
                            errors.Add(new PresetValidationIssue($"inputs.{field.GetString()}", "Provide a sample value for this required input."));
                if (schema.RootElement.TryGetProperty("properties", out var properties) && properties.ValueKind == JsonValueKind.Object)
                    foreach (var field in properties.EnumerateObject())
                    {
                        if (!inputs.TryGetProperty(field.Name, out var sample) || field.Value.ValueKind != JsonValueKind.Object ||
                            !field.Value.TryGetProperty("type", out var type) || type.ValueKind != JsonValueKind.String) continue;
                        var valid = type.GetString() switch
                        {
                            "string" => sample.ValueKind == JsonValueKind.String,
                            "number" => sample.ValueKind == JsonValueKind.Number,
                            "integer" => sample.ValueKind == JsonValueKind.Number && sample.TryGetInt64(out _),
                            "boolean" => sample.ValueKind is JsonValueKind.True or JsonValueKind.False,
                            "array" => sample.ValueKind == JsonValueKind.Array,
                            "object" => sample.ValueKind == JsonValueKind.Object,
                            _ => true
                        };
                        if (!valid) errors.Add(new PresetValidationIssue($"inputs.{field.Name}", $"Sample value must be {type.GetString()}."));
                    }
            }
        }
        catch (JsonException) { /* The draft validator reports invalid input schema JSON. */ }

        var remaining = draft.Workflow.Nodes.GroupBy(node => node.Key).Select(group => group.First())
            .OrderBy(node => node.Position).ThenBy(node => node.Key, StringComparer.Ordinal).ToList();
        var done = new HashSet<string>(StringComparer.Ordinal);
        var nodes = new List<AuthoringPreviewNodeResponse>();
        while (remaining.Count > 0)
        {
            var next = remaining.FirstOrDefault(node => draft.Workflow.Connections
                .Where(edge => edge.TargetNodeKey == node.Key).All(edge => done.Contains(edge.SourceNodeKey)));
            if (next is null) break;
            remaining.Remove(next);
            done.Add(next.Key);
            var mappings = new List<AuthoringPreviewMappingResponse>();
            try
            {
                var values = JsonSerializer.Deserialize<Dictionary<string, string>>(next.InputMappingJson) ?? [];
                foreach (var (name, path) in values)
                {
                    JsonElement? value = null;
                    var status = "Unresolved";
                    if (path.StartsWith("$.literal.", StringComparison.Ordinal))
                    {
                        value = JsonSerializer.SerializeToElement(path[10..]);
                        status = "Resolved";
                    }
                    else if (path.StartsWith("$.inputs.", StringComparison.Ordinal))
                    {
                        var key = path[9..];
                        var optional = key.EndsWith('?');
                        if (optional) key = key[..^1];
                        if (inputs.TryGetProperty(key, out var supplied)) { value = supplied.Clone(); status = "Resolved"; }
                        else if (optional) { value = JsonSerializer.SerializeToElement(""); status = "Optional"; }
                        else errors.Add(new PresetValidationIssue($"workflow.nodes.{next.Key}.inputMappingJson", $"Sample input '{key}' is missing."));
                    }
                    else if (path.StartsWith("$.nodes.", StringComparison.Ordinal)) status = "RequiresExecution";
                    mappings.Add(new AuthoringPreviewMappingResponse(name, path, status, value));
                }
            }
            catch (JsonException) { /* The validator reports malformed mappings. */ }
            nodes.Add(new AuthoringPreviewNodeResponse(next.Key, next.DisplayName, next.Type.ToString(), mappings));
        }
        return new AuthoringPreviewResponse(revision, new PresetValidationResult(errors), nodes);
    }
}
