using System.Text.Json;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Application.Services.Realtime;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class PresetAuthoringToolExecutor(
    IPresetAuthoringToolbox toolbox,
    IAuthoringRealtimeNotifier realtime)
{
    public async Task<string> ExecuteAsync(
        Guid sessionId,
        string name,
        JsonElement arguments,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("PresetAuthoringToolExecutor.Execute");
        await realtime.NotifyAsync(sessionId, "ToolStarted", new { name }, cancellationToken);
        string result;
        try
        {
            result = name switch
            {
                "list_capabilities" => await toolbox.ListCapabilitiesAsync(cancellationToken),
                "get_capability_details" => await toolbox.GetCapabilityDetailsAsync(
                    ReadRequiredString(arguments, "key"), cancellationToken),
                "save_preset_draft" => await toolbox.SaveDraftAsync(
                    sessionId, ReadRequiredJson(arguments, "draftJson"), cancellationToken),
                "validate_preset_draft" => await toolbox.ValidateDraftAsync(sessionId, cancellationToken),
                _ => throw new ArgumentException($"Unknown preset-authoring tool '{name}'.")
            };
        }
        catch (ArgumentException exception) when (IsKnownTool(name))
        {
            result = JsonSerializer.Serialize(new { error = exception.Message });
        }
        catch (JsonException exception) when (IsKnownTool(name))
        {
            result = JsonSerializer.Serialize(new { error = $"Invalid tool input: {exception.Message}" });
        }
        await toolbox.RecordToolResultAsync(sessionId, name, result, cancellationToken);
        await realtime.NotifyAsync(sessionId, "ToolCompleted", new { name }, cancellationToken);
        if (name == "save_preset_draft")
            await realtime.NotifyAsync(sessionId, "DraftUpdated", new { sessionId }, cancellationToken);
        return result;
    }

    private static bool IsKnownTool(string name) => name is
        "list_capabilities" or
        "get_capability_details" or
        "save_preset_draft" or
        "validate_preset_draft";

    private static string ReadRequiredString(JsonElement arguments, string name)
    {
        if (!arguments.TryGetProperty(name, out var value) || value.ValueKind != JsonValueKind.String ||
            string.IsNullOrWhiteSpace(value.GetString()))
            throw new ArgumentException($"Tool argument '{name}' is required.");
        return value.GetString()!;
    }

    private static string ReadRequiredJson(JsonElement arguments, string name)
    {
        if (!arguments.TryGetProperty(name, out var value))
            throw new ArgumentException($"Tool argument '{name}' is required.");
        return value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? throw new ArgumentException($"Tool argument '{name}' is required.")
            : value.GetRawText();
    }
}
