using System.Net;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Infrastructure.Agents;
using Microsoft.Extensions.Logging.Abstractions;

namespace ArzlyAI.Tests;

public sealed class AnthropicAgentRuntimeTests
{
    [Fact]
    public async Task ExecuteAsync_WhenMultipleSearchPasses_AccumulatesEvidenceBeforeFormatting()
    {
        var bodies = new List<string>();
        var requestCount = 0;
        var runtime = CreateRuntime(async request =>
        {
            requestCount++;
            bodies.Add(await request.Content!.ReadAsStringAsync());
            return JsonResponse(requestCount == 4
                ? """{"content":[{"type":"text","text":"{\"summary\":\"combined\"}"}]}"""
                : MessageResponse($"anthropic evidence {requestCount}"));
        });

        var output = await runtime.ExecuteAsync(
            CreateAgent(maxIterations: 8),
            """{"request":"Laptop"}""",
            "claude-sonnet-4-20250514",
            0.2,
            "key",
            CancellationToken.None);

        Assert.Contains("combined", output, StringComparison.Ordinal);
        Assert.Equal(4, requestCount);
        Assert.Contains("\"type\":\"web_search\"", bodies[0], StringComparison.Ordinal);
        Assert.Contains("anthropic evidence 1", bodies[1], StringComparison.Ordinal);
        Assert.Contains("anthropic evidence 2", bodies[2], StringComparison.Ordinal);
        Assert.DoesNotContain("\"tools\"", bodies[3], StringComparison.Ordinal);
        Assert.Contains("anthropic evidence 3", bodies[3], StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenMaxIterationsIsTwo_LimitsSearchPasses()
    {
        var requestCount = 0;
        var runtime = CreateRuntime(_ =>
        {
            requestCount++;
            return Task.FromResult(JsonResponse(MessageResponse(
                requestCount == 1 ? "first evidence" : """{"summary":"done"}""")));
        });

        var output = await runtime.ExecuteAsync(
            CreateAgent(maxIterations: 2),
            "Laptop",
            "claude-sonnet-4-20250514",
            null,
            "key",
            CancellationToken.None);

        Assert.Contains("done", output, StringComparison.Ordinal);
        Assert.Equal(2, requestCount);
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchModelUnsupported_ThrowsBeforeRequest()
    {
        var requestCount = 0;
        var runtime = CreateRuntime(_ =>
        {
            requestCount++;
            return Task.FromResult(JsonResponse(MessageResponse("unused")));
        });

        await Assert.ThrowsAsync<ArgumentException>(() => runtime.ExecuteAsync(
            CreateAgent(maxIterations: 3),
            "Laptop",
            "claude-3-haiku",
            null,
            "key",
            CancellationToken.None));

        Assert.Equal(0, requestCount);
    }

    [Fact]
    public async Task ExecuteAsync_WhenCancelled_DoesNotStartSearchPass()
    {
        var requestCount = 0;
        var runtime = CreateRuntime(_ =>
        {
            requestCount++;
            return Task.FromResult(JsonResponse(MessageResponse("unused")));
        });
        using var cancellation = new CancellationTokenSource();
        cancellation.Cancel();

        await Assert.ThrowsAnyAsync<OperationCanceledException>(() => runtime.ExecuteAsync(
            CreateAgent(maxIterations: 3),
            "Laptop",
            "claude-sonnet-4-20250514",
            null,
            "key",
            cancellation.Token));

        Assert.Equal(0, requestCount);
    }

    [Fact]
    public async Task ExecuteAsync_WhenSearchPassFails_DoesNotContinueLoop()
    {
        var requestCount = 0;
        var runtime = CreateRuntime(_ =>
        {
            requestCount++;
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.BadGateway));
        });

        await Assert.ThrowsAsync<HttpRequestException>(() => runtime.ExecuteAsync(
            CreateAgent(maxIterations: 8),
            "Laptop",
            "claude-sonnet-4-20250514",
            null,
            "key",
            CancellationToken.None));

        Assert.Equal(1, requestCount);
    }

    private static AnthropicAgentRuntime CreateRuntime(
        Func<HttpRequestMessage, Task<HttpResponseMessage>> handler) =>
        new(
            new HttpClient(new CapturingHandler(handler))
            {
                BaseAddress = new Uri("https://api.anthropic.com/")
            },
            new ProviderModelCapabilityPolicy(),
            NullLogger<AnthropicAgentRuntime>.Instance);

    private static AgentDefinition CreateAgent(int maxIterations) => new()
    {
        Id = Guid.NewGuid(),
        PresetId = Guid.NewGuid(),
        ModelId = Guid.NewGuid(),
        Key = "shop",
        Name = "Shop",
        Instructions = "Return JSON.",
        RuntimeType = AgentRuntimeType.Model,
        OutputSchemaJson = """{"type":"object"}""",
        Harness = new AgentHarnessDefinition
        {
            Id = Guid.NewGuid(),
            AgentId = Guid.NewGuid(),
            WebSearchEnabled = true,
            MaxIterations = maxIterations
        }
    };

    private static string MessageResponse(string text) =>
        JsonSerializer.Serialize(new
        {
            content = new[] { new { type = "text", text } }
        });

    private static HttpResponseMessage JsonResponse(string json) => new(HttpStatusCode.OK)
    {
        Content = new StringContent(json, Encoding.UTF8, "application/json")
    };

    private sealed class CapturingHandler(Func<HttpRequestMessage, Task<HttpResponseMessage>> handler)
        : HttpMessageHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken) =>
            handler(request);
    }
}
