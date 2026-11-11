using ArzlyAI.Domain.Enums;
using System.Text.Json.Serialization;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftAgent(
    string Key,
    string Name,
    string Instructions,
    [property: JsonConverter(typeof(JsonStringEnumConverter))] AgentRuntimeType RuntimeType,
    string ProviderKey,
    string ModelKey,
    double DefaultTemperature,
    double MinimumTemperature,
    double MaximumTemperature,
    bool AllowModelOverride,
    bool AllowTemperatureOverride,
    string? OutputSchemaJson,
    PresetDraftHarness Harness);
