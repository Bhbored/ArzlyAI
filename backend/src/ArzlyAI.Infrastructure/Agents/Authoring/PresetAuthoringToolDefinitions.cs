using System.Text.Json;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

internal static class PresetAuthoringToolDefinitions
{
    public static IReadOnlyList<AuthoringToolDefinition> All { get; } =
    [
        new("list_capabilities", "List every executable integration and deterministic operation.", "{\"type\":\"object\",\"properties\":{}}"),
        new("get_capability_details", "Get authoritative schemas and setup requirements for one capability.", "{\"type\":\"object\",\"properties\":{\"key\":{\"type\":\"string\"}},\"required\":[\"key\"]}"),
        new("save_preset_draft", "Save the complete typed preset draft JSON and return deterministic validation.", "{\"type\":\"object\",\"properties\":{\"draftJson\":{\"type\":\"string\"}},\"required\":[\"draftJson\"]}"),
        new("validate_preset_draft", "Validate the current draft without publishing it.", "{\"type\":\"object\",\"properties\":{}}")
    ];

    public static JsonElement Schema(AuthoringToolDefinition definition)
    {
        using var document = JsonDocument.Parse(definition.ParametersJson);
        return document.RootElement.Clone();
    }
}

internal sealed record AuthoringToolDefinition(string Name, string Description, string ParametersJson);
