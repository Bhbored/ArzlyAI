using System.Net;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Infrastructure.Agents.Authoring;

namespace ArzlyAI.Tests;

public sealed class AuthoringStreamingTests
{
    [Theory]
    [InlineData("deepseek")]
    [InlineData("anthropic")]
    [InlineData("gemini")]
    public async Task ReplyAsync_BeforeRemainingNetworkBytesArrive_AlreadyPublishesText(string provider)
    {
        var events = new RecordingNotifier();
        var transcript = Transcript(provider);
        var boundary = transcript.IndexOf("\n\n", transcript.IndexOf("Hello", StringComparison.Ordinal), StringComparison.Ordinal) + 2;
        using var client = new HttpClient(new ProgressiveHandler(
            transcript[..boundary], transcript[boundary..], () => Assert.Contains("Hello", events.Texts)))
            { BaseAddress = new Uri("https://provider.test/") };
        var agent = CreateAgent(provider, client, events, new Toolbox());
        Assert.Equal("Hello world", await agent.ReplyAsync(Guid.NewGuid(), [], "Hello", new AuthoringModelSelection(provider, "test"), "test-key", 30, default));
    }

    [Theory]
    [InlineData("deepseek")]
    [InlineData("anthropic")]
    [InlineData("gemini")]
    public async Task ReplyAsync_WhenProviderStreamsText_PublishesProgressAndReturnsCompleteReply(string provider)
    {
        var events = new RecordingNotifier();
        using var client = new HttpClient(new StreamingHandler(Transcript(provider))) { BaseAddress = new Uri("https://provider.test/") };
        var agent = CreateAgent(provider, client, events, new Toolbox());
        var result = await agent.ReplyAsync(Guid.NewGuid(), [], "Hello", new AuthoringModelSelection(provider, "test"), "test-key", 30, default);
        Assert.Equal("Hello world", result);
        Assert.Equal(new[] { "Hello", "Hello world" }, events.Texts);
    }

    [Theory]
    [InlineData("deepseek")]
    [InlineData("anthropic")]
    [InlineData("gemini")]
    public async Task ReplyAsync_WhenStreamEndsWithoutTerminalEvent_RejectsPartialReply(string provider)
    {
        var events = new RecordingNotifier();
        var firstFrame = Transcript(provider).Split("\n\n")[0] + "\n\n";
        using var client = new HttpClient(new StreamingHandler(firstFrame)) { BaseAddress = new Uri("https://provider.test/") };
        var agent = CreateAgent(provider, client, events, new Toolbox());
        await Assert.ThrowsAsync<HttpRequestException>(() => agent.ReplyAsync(Guid.NewGuid(), [], "Hello", new AuthoringModelSelection(provider, "test"), "test-key", 30, default));
    }

    [Fact]
    public async Task ReplyAsync_WhenToolArgumentsAreFragmented_ExecutesCompleteToolThenStreamsReply()
    {
        var toolFrames = Frame(new { choices = new[] { new { delta = new { tool_calls = new[] { new { index = 0, id = "call1", function = new { name = "get_capability_details", arguments = "{\"key\":" } } } } } } })
            + Frame(new { choices = new[] { new { delta = new { tool_calls = new[] { new { index = 0, function = new { arguments = "\"email\"}" } } } }, finish_reason = "tool_calls" } } });
        var toolbox = new Toolbox();
        var events = new RecordingNotifier();
        using var client = new HttpClient(new StreamingHandler(toolFrames, Transcript("deepseek"))) { BaseAddress = new Uri("https://provider.test/") };
        var agent = CreateAgent("deepseek", client, events, toolbox);
        Assert.Equal("Hello world", await agent.ReplyAsync(Guid.NewGuid(), [], "Hello", new AuthoringModelSelection("deepseek", "test"), "test-key", 30, default));
        Assert.Equal("email", toolbox.Key);
        Assert.Equal(1, toolbox.RecordCount);
    }

    [Fact]
    public async Task ReadAsync_WhenFramesContainCommentsMultilineDataAndUnicode_PreservesData()
    {
        using var stream = new MemoryStream(Encoding.UTF8.GetBytes(": keepalive\r\nevent: message\r\ndata: مرحبا\r\ndata: world\r\n\r\ndata: [DONE]\r\n\r\n"));
        var frames = new List<string>();
        await foreach (var frame in AuthoringSseReader.ReadAsync(stream, default)) frames.Add(frame);
        Assert.Equal(new[] { "مرحبا\nworld", "[DONE]" }, frames);
    }

    private static string Frame(object value) => "data: " + JsonSerializer.Serialize(value) + "\n\n";

    private static string Transcript(string provider) => provider switch
    {
        "deepseek" => Frame(new { choices = new[] { new { delta = new { content = "Hello" } } } })
            + Frame(new { choices = new[] { new { delta = new { content = " world" }, finish_reason = "stop" } } }) + "data: [DONE]\n\n",
        "anthropic" => Frame(new { type = "content_block_start", index = 0, content_block = new { type = "text", text = "" } })
            + Frame(new { type = "content_block_delta", index = 0, delta = new { type = "text_delta", text = "Hello" } })
            + Frame(new { type = "content_block_delta", index = 0, delta = new { type = "text_delta", text = " world" } })
            + Frame(new { type = "message_stop" }),
        _ => Frame(new { candidates = new[] { new { content = new { parts = new[] { new { text = "Hello" } } } } } })
            + Frame(new { candidates = new[] { new { content = new { parts = new[] { new { text = " world" } } }, finishReason = "STOP" } } })
    };

    private static IPresetAuthoringProviderAgent CreateAgent(string provider, HttpClient client, RecordingNotifier notifier, Toolbox toolbox)
    {
        var tools = new PresetAuthoringToolExecutor(toolbox, notifier);
        return provider switch
        {
            "deepseek" => new DeepSeekPresetAuthoringAgent(client, tools, notifier),
            "anthropic" => new AnthropicPresetAuthoringAgent(client, tools, notifier),
            _ => new GeminiPresetAuthoringAgent(client, tools, notifier)
        };
    }

    private sealed class StreamingHandler(params string[] responses) : HttpMessageHandler
    {
        private int index;
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken) =>
            Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent(responses[index++], Encoding.UTF8, "text/event-stream") });
    }

    private sealed class ProgressiveHandler(string first, string rest, Action beforeRest) : HttpMessageHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken) =>
            Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StreamContent(new ProgressiveStream(first, rest, beforeRest)) });
    }

    private sealed class ProgressiveStream(string first, string rest, Action beforeRest) : Stream
    {
        private readonly byte[] initial = Encoding.UTF8.GetBytes(first);
        private readonly byte[] remaining = Encoding.UTF8.GetBytes(rest);
        private int position;
        private bool checkedProgress;
        public override bool CanRead => true;
        public override bool CanSeek => false;
        public override bool CanWrite => false;
        public override long Length => throw new NotSupportedException();
        public override long Position { get => throw new NotSupportedException(); set => throw new NotSupportedException(); }
        public override ValueTask<int> ReadAsync(Memory<byte> buffer, CancellationToken cancellationToken = default)
        {
            cancellationToken.ThrowIfCancellationRequested();
            var source = initial;
            var offset = position;
            if (position >= initial.Length)
            {
                if (!checkedProgress) { beforeRest(); checkedProgress = true; }
                source = remaining;
                offset -= initial.Length;
            }
            var count = Math.Min(buffer.Length, source.Length - offset);
            source.AsMemory(offset, count).CopyTo(buffer);
            position += count;
            return ValueTask.FromResult(count);
        }
        public override Task<int> ReadAsync(byte[] buffer, int offset, int count, CancellationToken cancellationToken) =>
            ReadAsync(buffer.AsMemory(offset, count), cancellationToken).AsTask();
        public override int Read(byte[] buffer, int offset, int count) => throw new NotSupportedException();
        public override void Flush() => throw new NotSupportedException();
        public override long Seek(long offset, SeekOrigin origin) => throw new NotSupportedException();
        public override void SetLength(long value) => throw new NotSupportedException();
        public override void Write(byte[] buffer, int offset, int count) => throw new NotSupportedException();
    }

    private sealed class RecordingNotifier : IAuthoringRealtimeNotifier
    {
        public List<string> Texts { get; } = [];
        public Task NotifyAsync(Guid sessionId, string eventName, object payload, CancellationToken cancellationToken)
        {
            if (eventName == "AssistantTextUpdated") Texts.Add(JsonSerializer.SerializeToElement(payload).GetProperty("text").GetString()!);
            return Task.CompletedTask;
        }
    }

    private sealed class Toolbox : IPresetAuthoringToolbox
    {
        public string? Key { get; private set; }
        public int RecordCount { get; private set; }
        public Task<string> ListCapabilitiesAsync(CancellationToken cancellationToken) => Task.FromResult("[]");
        public Task<string> GetCapabilityDetailsAsync(string key, CancellationToken cancellationToken) { Key = key; return Task.FromResult("{}"); }
        public Task<string> SaveDraftAsync(Guid sessionId, string draftJson, CancellationToken cancellationToken) => Task.FromResult("{}");
        public Task<string> ValidateDraftAsync(Guid sessionId, CancellationToken cancellationToken) => Task.FromResult("{}");
        public Task RecordToolResultAsync(Guid sessionId, string toolName, string resultJson, CancellationToken cancellationToken) { RecordCount++; return Task.CompletedTask; }
    }
}
