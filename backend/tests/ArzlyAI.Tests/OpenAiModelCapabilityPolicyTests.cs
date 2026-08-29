using ArzlyAI.Application.Services.Models;

namespace ArzlyAI.Tests;

public sealed class OpenAiModelCapabilityPolicyTests
{
    private readonly OpenAiModelCapabilityPolicy policy = new();

    [Theory]
    [InlineData("gpt-4.1-mini", true)]
    [InlineData("gpt-4o", true)]
    [InlineData("gpt-5-mini", false)]
    [InlineData("o3", false)]
    public void SupportsTemperature_WhenModelVaries_ReturnsExpected(
        string model,
        bool expected)
    {
        Assert.Equal(expected, policy.SupportsTemperature("openai", model));
    }

    [Theory]
    [InlineData("gpt-4.1-mini", true)]
    [InlineData("gpt-5-mini", true)]
    [InlineData("gpt-image-1", false)]
    [InlineData("whisper-1", false)]
    public void IsUsable_WhenModelVaries_ReturnsExpected(string model, bool expected)
    {
        Assert.Equal(expected, policy.IsUsable("openai", model));
    }
}
