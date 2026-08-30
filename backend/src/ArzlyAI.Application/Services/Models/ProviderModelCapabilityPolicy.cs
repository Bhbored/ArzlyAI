using ArzlyAI.Application.Constants;

namespace ArzlyAI.Application.Services.Models;

public sealed class ProviderModelCapabilityPolicy : IModelCapabilityPolicy
{
    public bool IsUsable(string provider, string model) =>
        provider.ToLowerInvariant() switch
        {
            AiProviderKeys.OpenAi => OpenAiCapabilityRules.IsUsable(model),
            AiProviderKeys.Anthropic => AnthropicCapabilityRules.IsUsable(model),
            AiProviderKeys.Gemini => GeminiCapabilityRules.IsUsable(model),
            AiProviderKeys.DeepSeek => DeepSeekCapabilityRules.IsUsable(model),
            _ => false
        };

    public bool SupportsTemperature(string provider, string model) =>
        provider.ToLowerInvariant() switch
        {
            AiProviderKeys.OpenAi => OpenAiCapabilityRules.SupportsTemperature(model),
            AiProviderKeys.Anthropic => AnthropicCapabilityRules.SupportsTemperature(model),
            AiProviderKeys.Gemini => GeminiCapabilityRules.SupportsTemperature(model),
            AiProviderKeys.DeepSeek => DeepSeekCapabilityRules.SupportsTemperature(model),
            _ => false
        };

    public bool SupportsWebSearch(string provider, string model) =>
        provider.ToLowerInvariant() switch
        {
            AiProviderKeys.OpenAi => OpenAiCapabilityRules.SupportsWebSearch(model),
            AiProviderKeys.Anthropic => AnthropicCapabilityRules.SupportsWebSearch(model),
            AiProviderKeys.Gemini => GeminiCapabilityRules.SupportsWebSearch(model),
            AiProviderKeys.DeepSeek => DeepSeekCapabilityRules.SupportsWebSearch(model),
            _ => false
        };
}
