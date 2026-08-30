using System.Net;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Infrastructure.Agents;
using Microsoft.Extensions.Logging.Abstractions;

namespace ArzlyAI.Tests;

public sealed class DeepSeekAgentRuntimeTests
{
    [Fact]
    public async Task ExecuteAsync_WhenOutputSchema_UsesJsonObjectOnChatCompletions()
    {
        string? capturedBody = null;
        var handler = new CapturingHandler(async request =>
        {
            capturedBody = await request.Content!.ReadAsStringAsync();
            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(
                    "{\"choices\":[{\"message\":{\"content\":\"{\\\"summary\\\":\\\"test\\\"}\"}}]}",
                    Encoding.UTF8,
                    "application/json")
            };
        });
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: false, outputSchema: """{"type":"object"}""");

        var output = await runtime.ExecuteAsync(
            definition,
            """{"purchaseGoal":"Headphones"}""",
            "deepseek-chat",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("summary", output, StringComparison.Ordinal);
        Assert.NotNull(capturedBody);
        using var document = JsonDocument.Parse(capturedBody);
        Assert.Equal("json_object", document.RootElement.GetProperty("response_format").GetProperty("type").GetString());
        Assert.DoesNotContain("json_schema", capturedBody, StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchEnabled_ExtractsResponsesMessageOutput()
    {
        const string responseBody = """
            {
              "status": "completed",
              "output": [
                {
                  "type": "web_search_call",
                  "status": "completed"
                },
                {
                  "type": "message",
                  "role": "assistant",
                  "content": [
                    { "type": "output_text", "text": "{\"summary\":\"found options\"}" }
                  ]
                }
              ]
            }
            """;
        string? capturedBody = null;
        Uri? requestUri = null;
        var handler = new CapturingHandler(async request =>
        {
            requestUri = request.RequestUri;
            capturedBody = await request.Content!.ReadAsStringAsync();
            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(responseBody, Encoding.UTF8, "application/json")
            };
        });
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: true, outputSchema: """{"type":"object"}""");

        var output = await runtime.ExecuteAsync(
            definition,
            """{"request":"Laptop under $800"}""",
            "deepseek-v4-flash",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("found options", output, StringComparison.Ordinal);
        Assert.NotNull(capturedBody);
        Assert.NotNull(requestUri);
        Assert.EndsWith("/responses", requestUri!.AbsolutePath, StringComparison.OrdinalIgnoreCase);
        using var document = JsonDocument.Parse(capturedBody);
        Assert.Equal(8192, document.RootElement.GetProperty("max_output_tokens").GetInt32());
        Assert.False(document.RootElement.TryGetProperty("text", out _));
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchEnabledWithSchema_ExtractsJsonFromReasoningWhenMessageMissing()
    {
        const string responseBody = """
            {
              "status": "completed",
              "output": [
                {
                  "type": "web_search_call",
                  "status": "completed"
                },
                {
                  "type": "reasoning",
                  "content": [
                    { "type": "reasoning_text", "text": "{\"summary\":\"from reasoning\"}" }
                  ]
                }
              ]
            }
            """;
        var handler = new CapturingHandler(_ =>
            Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(responseBody, Encoding.UTF8, "application/json")
            }));
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: true, outputSchema: """{"type":"object"}""");

        var output = await runtime.ExecuteAsync(
            definition,
            """{"request":"Laptop under $800"}""",
            "deepseek-v4-flash",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("from reasoning", output, StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchEnabledWithSchema_ExtractsJsonFromStringMessageContent()
    {
        const string responseBody = """
            {
              "status": "completed",
              "output": [
                {
                  "type": "message",
                  "role": "assistant",
                  "content": "{\"summary\":\"string content\"}"
                }
              ]
            }
            """;
        var handler = new CapturingHandler(_ =>
            Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(responseBody, Encoding.UTF8, "application/json")
            }));
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: true, outputSchema: """{"type":"object"}""");

        var output = await runtime.ExecuteAsync(
            definition,
            """{"request":"Laptop under $800"}""",
            "deepseek-v4-flash",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("string content", output, StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchEnabledWithSchema_IgnoresPlainReasoningText()
    {
        const string responseBody = """
            {
              "status": "completed",
              "output": [
                {
                  "type": "reasoning",
                  "content": [
                    { "type": "reasoning_text", "text": "I'll research Nike shoes available in Lebanon." }
                  ]
                }
              ]
            }
            """;
        var handler = new CapturingHandler(_ =>
            Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(responseBody, Encoding.UTF8, "application/json")
            }));
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: true, outputSchema: """{"type":"object"}""");

        var exception = await Assert.ThrowsAsync<InvalidOperationException>(() =>
            runtime.ExecuteAsync(
                definition,
                """{"request":"Laptop under $800"}""",
                "deepseek-v4-flash",
                0.2,
                "ds-key",
                CancellationToken.None));

        Assert.Contains("returned no output", exception.Message, StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchEnabledWithoutSchema_ExtractsReasoningFallbackText()
    {
        const string responseBody = """
            {
              "status": "completed",
              "output": [
                {
                  "type": "reasoning",
                  "content": [
                    { "type": "reasoning_text", "text": "plain reasoning summary" }
                  ]
                }
              ]
            }
            """;
        var handler = new CapturingHandler(_ =>
            Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(responseBody, Encoding.UTF8, "application/json")
            }));
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: true, outputSchema: null);

        var output = await runtime.ExecuteAsync(
            definition,
            """{"request":"Laptop under $800"}""",
            "deepseek-v4-flash",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("plain reasoning summary", output, StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenOutputSchemaRequired_FormatsPlainTextMessageAsJson()
    {
        const string responseBody = """
            {
              "status": "completed",
              "output": [
                {
                  "type": "message",
                  "role": "assistant",
                  "content": [
                    { "type": "output_text", "text": "I'll research Nike shoes available in Lebanon." }
                  ]
                },
                {
                  "type": "message",
                  "role": "assistant",
                  "content": [
                    { "type": "output_text", "text": "Found Nike Revolution 8 at Mike Sport for $85 and Nike Air Max DN8 at Marka Store for $175." }
                  ]
                }
              ]
            }
            """;
        var requestCount = 0;
        string? formattingRequest = null;
        var handler = new CapturingHandler(async request =>
        {
            requestCount++;
            if (requestCount == 2)
            {
                formattingRequest = await request.Content!.ReadAsStringAsync();
                return new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new StringContent(
                        "{\"choices\":[{\"message\":{\"content\":\"{\\\"summary\\\":\\\"formatted report\\\"}\"}}]}",
                        Encoding.UTF8,
                        "application/json")
                };
            }

            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(responseBody, Encoding.UTF8, "application/json")
            };
        });
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: true, outputSchema: """{"type":"object"}""");

        var output = await runtime.ExecuteAsync(
            definition,
            """{"request":"Nike shoes in Lebanon"}""",
            "deepseek-v4-flash",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("formatted report", output, StringComparison.Ordinal);
        Assert.Equal(2, requestCount);
        Assert.Contains("Nike shoes available in Lebanon", formattingRequest, StringComparison.Ordinal);
        Assert.Contains("Nike Revolution 8", formattingRequest, StringComparison.Ordinal);
        Assert.Contains("Nike Air Max DN8", formattingRequest, StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenMultipleSearchPasses_AccumulatesEvidenceBeforeFormatting()
    {
        var requestBodies = new List<string>();
        var requestPaths = new List<string>();
        var requestCount = 0;
        var handler = new CapturingHandler(async request =>
        {
            requestCount++;
            requestPaths.Add(request.RequestUri!.AbsolutePath);
            requestBodies.Add(await request.Content!.ReadAsStringAsync());
            if (requestCount == 4)
            {
                return new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new StringContent(
                        "{\"choices\":[{\"message\":{\"content\":\"{\\\"summary\\\":\\\"combined report\\\"}\"}}]}",
                        Encoding.UTF8,
                        "application/json")
                };
            }

            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(
                    ResponseWithMessage($"research evidence {requestCount}"),
                    Encoding.UTF8,
                    "application/json")
            };
        });
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(
            webSearchEnabled: true,
            outputSchema: """{"type":"object"}""",
            maxIterations: 8);

        var output = await runtime.ExecuteAsync(
            definition,
            """{"request":"Gaming laptop"}""",
            "deepseek-v4-flash",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("combined report", output, StringComparison.Ordinal);
        Assert.Equal(4, requestCount);
        Assert.Equal("/responses", requestPaths[0]);
        Assert.Equal("/responses", requestPaths[1]);
        Assert.Equal("/responses", requestPaths[2]);
        Assert.Equal("/chat/completions", requestPaths[3]);
        Assert.Contains("research evidence 1", requestBodies[1], StringComparison.Ordinal);
        Assert.Contains("research evidence 1", requestBodies[2], StringComparison.Ordinal);
        Assert.Contains("research evidence 2", requestBodies[2], StringComparison.Ordinal);
        Assert.Contains("research evidence 1", requestBodies[3], StringComparison.Ordinal);
        Assert.Contains("research evidence 3", requestBodies[3], StringComparison.Ordinal);
    }

    [Fact]
    public async Task ExecuteAsync_WhenMaxIterationsIsTwo_LimitsNativeSearchPasses()
    {
        var requestCount = 0;
        var handler = new CapturingHandler(_ =>
        {
            requestCount++;
            var content = requestCount == 1
                ? "first pass evidence"
                : "{\"summary\":\"second pass report\"}";
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(
                    ResponseWithMessage(content),
                    Encoding.UTF8,
                    "application/json")
            });
        });
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(
            webSearchEnabled: true,
            outputSchema: """{"type":"object"}""",
            maxIterations: 2);

        var output = await runtime.ExecuteAsync(
            definition,
            """{"request":"Laptop"}""",
            "deepseek-v4-flash",
            0.2,
            "ds-key",
            CancellationToken.None);

        Assert.Contains("second pass report", output, StringComparison.Ordinal);
        Assert.Equal(2, requestCount);
    }

    [Fact]
    public async Task ExecuteAsync_WhenCancelled_DoesNotStartSearchPass()
    {
        var requestCount = 0;
        var handler = new CapturingHandler(_ =>
        {
            requestCount++;
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK));
        });
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(
            webSearchEnabled: true,
            outputSchema: """{"type":"object"}""",
            maxIterations: 8);
        using var cancellation = new CancellationTokenSource();
        cancellation.Cancel();

        await Assert.ThrowsAnyAsync<OperationCanceledException>(() =>
            runtime.ExecuteAsync(
                definition,
                """{"request":"Laptop"}""",
                "deepseek-v4-flash",
                0.2,
                "ds-key",
                cancellation.Token));

        Assert.Equal(0, requestCount);
    }

    [Fact]
    public async Task ExecuteAsync_WhenSearchPassFails_DoesNotContinueLoop()
    {
        var requestCount = 0;
        var handler = new CapturingHandler(_ =>
        {
            requestCount++;
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.BadGateway)
            {
                Content = new StringContent("search unavailable")
            });
        });
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(
            webSearchEnabled: true,
            outputSchema: """{"type":"object"}""",
            maxIterations: 8);

        var exception = await Assert.ThrowsAsync<InvalidOperationException>(() =>
            runtime.ExecuteAsync(
                definition,
                """{"request":"Laptop"}""",
                "deepseek-v4-flash",
                0.2,
                "ds-key",
                CancellationToken.None));

        Assert.Contains("502", exception.Message, StringComparison.Ordinal);
        Assert.Equal(1, requestCount);
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchModelUnsupported_ThrowsBeforeRequest()
    {
        var handler = new CapturingHandler(_ =>
            Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)));
        var client = new HttpClient(handler) { BaseAddress = new Uri("https://api.deepseek.com/") };
        var runtime = new DeepSeekAgentRuntime(
            client,
            new ProviderModelCapabilityPolicy(),
            NullLogger<DeepSeekAgentRuntime>.Instance);
        var definition = CreateAgent(webSearchEnabled: true, outputSchema: """{"type":"object"}""");

        var exception = await Assert.ThrowsAsync<ArgumentException>(() =>
            runtime.ExecuteAsync(
                definition,
                """{"request":"Laptop under $800"}""",
                "deepseek-chat",
                0.2,
                "ds-key",
                CancellationToken.None));

        Assert.Contains("deepseek-v4-flash", exception.Message, StringComparison.Ordinal);
    }

    private static AgentDefinition CreateAgent(
        bool webSearchEnabled,
        string? outputSchema,
        int maxIterations = 0) => new()
    {
        Id = Guid.NewGuid(),
        PresetId = Guid.NewGuid(),
        ModelId = Guid.NewGuid(),
        Key = "understand-request",
        Name = "Understand Request",
        Instructions = "Return only the required JSON.",
        RuntimeType = AgentRuntimeType.Model,
        OutputSchemaJson = outputSchema,
        Harness = new AgentHarnessDefinition
        {
            Id = Guid.NewGuid(),
            AgentId = Guid.NewGuid(),
            WebSearchEnabled = webSearchEnabled,
            MaxIterations = maxIterations
        }
    };

    private static string ResponseWithMessage(string content) =>
        JsonSerializer.Serialize(new
        {
            status = "completed",
            output = new[]
            {
                new
                {
                    type = "message",
                    role = "assistant",
                    content = new[] { new { type = "output_text", text = content } }
                }
            }
        });

    private sealed class CapturingHandler(Func<HttpRequestMessage, Task<HttpResponseMessage>> handler)
        : HttpMessageHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken) =>
            handler(request);
    }
}
