namespace ArzlyAI.Application.DTOs.Presets;
public sealed record AgentModelConfigurationResponse(
    string Provider,
    string SelectedModel,
    IReadOnlyList<ModelOptionResponse> AvailableModels,
    bool IsModelEditable,
    double Temperature,
    double MinimumTemperature,
    double MaximumTemperature,
    bool IsTemperatureEditable,
    bool SupportsWebSearch);
