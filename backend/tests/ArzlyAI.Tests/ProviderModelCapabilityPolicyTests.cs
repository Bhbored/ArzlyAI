using ArzlyAI.Application.Constants;
using ArzlyAI.Application.Services.Models;

namespace ArzlyAI.Tests;

public sealed class ProviderModelCapabilityPolicyTests
{
    private readonly ProviderModelCapabilityPolicy policy = new();

    [Theory]
    [InlineData("gpt-4.1-mini", true)]
    [InlineData("gpt-4o", true)]
    [InlineData("gpt-5-mini", false)]
    [InlineData("o3", false)]
    public void SupportsTemperature_WhenOpenAiModelVaries_ReturnsExpected(
        string model,
        bool expected)
    {
        Assert.Equal(expected, policy.SupportsTemperature(AiProviderKeys.OpenAi, model));
    }

    [Theory]
    [InlineData("gpt-4.1-mini", true)]
    [InlineData("gpt-5-mini", true)]
    [InlineData("gpt-image-1", false)]
    [InlineData("whisper-1", false)]
    public void IsUsable_WhenOpenAiModelVaries_ReturnsExpected(string model, bool expected)
    {
        Assert.Equal(expected, policy.IsUsable(AiProviderKeys.OpenAi, model));
    }

    [Theory]
    [InlineData(AiProviderKeys.DeepSeek, "deepseek-chat", false)]
    [InlineData(AiProviderKeys.Anthropic, "claude-sonnet-4-20250514", true)]
    [InlineData(AiProviderKeys.Gemini, "gemini-2.5-flash", true)]
    public void SupportsWebSearch_WhenProviderVaries_ReturnsExpected(
        string provider,
        string model,
        bool expected)
    {
        Assert.Equal(expected, policy.SupportsWebSearch(provider, model));
    }
}
