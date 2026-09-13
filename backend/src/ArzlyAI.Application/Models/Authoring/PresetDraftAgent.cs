using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftAgent(
    string Key,
    string Name,
    string Instructions,
    AgentRuntimeType RuntimeType,
    string ProviderKey,
    string ModelKey,
    double DefaultTemperature,
    double MinimumTemperature,
    double MaximumTemperature,
    bool AllowModelOverride,
    bool AllowTemperatureOverride,
    string? OutputSchemaJson,
    PresetDraftHarness Harness);
