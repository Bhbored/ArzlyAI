using System.Text.Json;
using System.Text.Json.Serialization;
using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public static class PresetDraftSerializer
{
    public static JsonSerializerOptions Options { get; } = CreateOptions();

    public static PresetDraftDocument Deserialize(string json) =>
        JsonSerializer.Deserialize<PresetDraftDocument>(json, Options)
        ?? throw new ArgumentException("The preset draft is empty.");

    public static PresetValidationResult DeserializeValidation(string json) =>
        JsonSerializer.Deserialize<PresetValidationResult>(json, Options)
        ?? new PresetValidationResult([new PresetValidationIssue("validation", "Validation is unavailable.")]);

    public static string Serialize<T>(T value) => JsonSerializer.Serialize(value, Options);

    private static JsonSerializerOptions CreateOptions()
    {
        var options = new JsonSerializerOptions(JsonSerializerDefaults.Web);
        options.Converters.Add(new JsonStringEnumConverter());
        return options;
    }
}
