using ArzlyAI.Application.Constants;
using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Services.Agents;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Tests;

public sealed class AgentWorkflowNodeHandlerTests
{
    private readonly ProviderModelCapabilityPolicy capabilities = new();

    [Fact]
    public async Task ExecuteAsync_WhenProviderOverride_UsesMatchingRuntimeAndCredentialKey()
    {
        var runtime = new RecordingAgentRuntime(AiProviderKeys.OpenAi, "ok");
        var handler = new AgentWorkflowNodeHandler(
            new StubRuntimeResolver(runtime),
            capabilities);
        var preset = CreatePreset(webSearch: false);
        var step = preset.Workflow.Steps.Single(s => s.ReferenceKey == "writer");
        var context = new WorkflowNodeExecutionContext(
            preset,
            step,
            new WorkflowRun { Id = Guid.NewGuid(), PresetKey = preset.Key },
            new Dictionary<string, string> { ["topic"] = "hello" },
            new Dictionary<string, string> { ["openai.apiKey"] = "openai-key" },
            new AgentOverrideRequest("writer", AiProviderKeys.OpenAi, "gpt-4.1-mini", 0.7));

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal("hello", runtime.LastInput);
        Assert.Equal("gpt-4.1-mini", runtime.LastModel);
        Assert.Equal(0.7, runtime.LastTemperature);
        Assert.Equal("openai-key", runtime.LastApiKey);
        Assert.Equal(AiProviderKeys.OpenAi, result.EffectiveProvider);
        Assert.Equal("gpt-4.1-mini", result.EffectiveModel);
    }

    [Theory]
    [InlineData(AiProviderKeys.OpenAi, "gpt-4.1-mini")]
    [InlineData(AiProviderKeys.Anthropic, "claude-sonnet-4-20250514")]
    [InlineData(AiProviderKeys.Gemini, "gemini-2.5-flash")]
    [InlineData(AiProviderKeys.DeepSeek, "deepseek-chat")]
    public async Task ExecuteAsync_WhenLinkedInWriterUsesSupportedProvider_ExecutesMatchingModel(
        string provider,
        string model)
    {
        var runtime = new RecordingAgentRuntime(provider, "draft");
        var handler = new AgentWorkflowNodeHandler(
            new StubRuntimeResolver(runtime),
            capabilities);
        var preset = CreatePreset(webSearch: false);
        var step = preset.Workflow.Steps.Single(candidate => candidate.ReferenceKey == "writer");
        var context = new WorkflowNodeExecutionContext(
            preset,
            step,
            new WorkflowRun { Id = Guid.NewGuid(), PresetKey = "daily-linkedin-ai-post" },
            new Dictionary<string, string> { ["topic"] = "AI" },
            new Dictionary<string, string> { [$"{provider}.apiKey"] = "provider-key" },
            new AgentOverrideRequest("writer", provider, model, null));

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(provider, result.EffectiveProvider);
        Assert.Equal(model, result.EffectiveModel);
        Assert.Equal("provider-key", runtime.LastApiKey);
        Assert.Equal("draft", result.Output);
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchRequiredAndUnsupported_Throws()
    {
        var runtime = new RecordingAgentRuntime(AiProviderKeys.OpenAi, "ok");
        var handler = new AgentWorkflowNodeHandler(
            new StubRuntimeResolver(runtime),
            capabilities);
        var preset = CreatePreset(webSearch: true);
        var step = preset.Workflow.Steps.Single(s => s.ReferenceKey == "writer");
        var context = new WorkflowNodeExecutionContext(
            preset,
            step,
            new WorkflowRun { Id = Guid.NewGuid(), PresetKey = preset.Key },
            new Dictionary<string, string> { ["topic"] = "hello" },
            new Dictionary<string, string> { ["openai.apiKey"] = "openai-key" },
            new AgentOverrideRequest("writer", AiProviderKeys.OpenAi, "gpt-3.5-turbo", null));

        await Assert.ThrowsAsync<ArgumentException>(() =>
            handler.ExecuteAsync(context, CancellationToken.None));
    }

    [Fact]
    public async Task ExecuteAsync_WhenWebSearchRequiredAndDeepSeekSelected_DoesNotThrowBeforeRuntime()
    {
        var runtime = new RecordingAgentRuntime(AiProviderKeys.DeepSeek, "ok");
        var handler = new AgentWorkflowNodeHandler(
            new StubRuntimeResolver(runtime),
            capabilities);
        var preset = CreatePreset(webSearch: true);
        var step = preset.Workflow.Steps.Single(s => s.ReferenceKey == "writer");
        var context = new WorkflowNodeExecutionContext(
            preset,
            step,
            new WorkflowRun { Id = Guid.NewGuid(), PresetKey = preset.Key },
            new Dictionary<string, string> { ["topic"] = "hello" },
            new Dictionary<string, string> { ["deepseek.apiKey"] = "ds-key" },
            new AgentOverrideRequest("writer", AiProviderKeys.DeepSeek, "deepseek-v4-flash", null));

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(AiProviderKeys.DeepSeek, result.EffectiveProvider);
        Assert.Equal("deepseek-v4-flash", result.EffectiveModel);
    }

    [Fact]
    public async Task ExecuteAsync_WhenModelOverrideWithoutProvider_InfersProviderFromModel()
    {
        var runtime = new RecordingAgentRuntime(AiProviderKeys.DeepSeek, "ok");
        var handler = new AgentWorkflowNodeHandler(
            new StubRuntimeResolver(runtime),
            capabilities);
        var preset = CreatePreset(webSearch: true);
        var step = preset.Workflow.Steps.Single(s => s.ReferenceKey == "writer");
        var context = new WorkflowNodeExecutionContext(
            preset,
            step,
            new WorkflowRun { Id = Guid.NewGuid(), PresetKey = preset.Key },
            new Dictionary<string, string> { ["topic"] = "hello" },
            new Dictionary<string, string> { ["deepseek.apiKey"] = "ds-key" },
            new AgentOverrideRequest("writer", null, "deepseek-v4-flash", null));

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(AiProviderKeys.DeepSeek, result.EffectiveProvider);
        Assert.Equal("deepseek-v4-flash", result.EffectiveModel);
        Assert.Equal("ds-key", runtime.LastApiKey);
    }

    [Fact]
    public async Task ExecuteAsync_WhenNoShopOverride_InheritsProviderFromCompletedAgent()
    {
        var runtime = new RecordingAgentRuntime(AiProviderKeys.DeepSeek, "ok");
        var handler = new AgentWorkflowNodeHandler(
            new StubRuntimeResolver(runtime),
            capabilities);
        var preset = CreatePreset(webSearch: true);
        var step = preset.Workflow.Steps.Single(s => s.ReferenceKey == "writer");
        var run = new WorkflowRun
        {
            Id = Guid.NewGuid(),
            PresetKey = preset.Key,
            AgentOverrides =
            [
                new AgentOverrideRequest("writer", AiProviderKeys.DeepSeek, "deepseek-v4-flash", null)
            ],
            Nodes =
            [
                new WorkflowNodeRun
                {
                    NodeId = Guid.NewGuid(),
                    NodeKey = "planner",
                    DisplayName = "Planner",
                    Type = WorkflowNodeType.Agent,
                    Status = WorkflowNodeStatus.Completed,
                    EffectiveProvider = AiProviderKeys.DeepSeek,
                    EffectiveModel = "deepseek-v4-flash"
                }
            ]
        };
        var context = new WorkflowNodeExecutionContext(
            preset,
            step,
            run,
            new Dictionary<string, string> { ["topic"] = "hello" },
            new Dictionary<string, string> { ["deepseek.apiKey"] = "ds-key" },
            null);

        var result = await handler.ExecuteAsync(context, CancellationToken.None);

        Assert.Equal(AiProviderKeys.DeepSeek, result.EffectiveProvider);
        Assert.Equal("deepseek-v4-flash", result.EffectiveModel);
        Assert.Equal("ds-key", runtime.LastApiKey);
    }

    private static PresetDefinition CreatePreset(bool webSearch)
    {
        var provider = new ProviderDefinition
        {
            Id = Guid.NewGuid(),
            Key = AiProviderKeys.OpenAi,
            DisplayName = "OpenAI"
        };
        var model = new ModelDefinition
        {
            Id = Guid.NewGuid(),
            ProviderId = provider.Id,
            Key = "gpt-5-mini",
            DisplayName = "GPT-5 mini",
            Provider = provider
        };
        provider.Models.Add(model);
        var preset = new PresetDefinition
        {
            Id = Guid.NewGuid(),
            Key = "preset",
            Name = "Preset",
            Description = "Description",
            Version = 1,
            IsPublished = true,
            UpdatedAtUtc = DateTimeOffset.UtcNow
        };
        var agent = new AgentDefinition
        {
            Id = Guid.NewGuid(),
            PresetId = preset.Id,
            ModelId = model.Id,
            Key = "writer",
            Name = "Writer",
            Instructions = "Write",
            RuntimeType = AgentRuntimeType.Model,
            DefaultTemperature = .7,
            MinimumTemperature = 0,
            MaximumTemperature = 1,
            AllowModelOverride = true,
            AllowTemperatureOverride = true,
            Model = model,
            Preset = preset
        };
        var harness = new AgentHarnessDefinition
        {
            Id = Guid.NewGuid(),
            AgentId = agent.Id,
            Agent = agent,
            MaxIterations = 3,
            WebSearchEnabled = webSearch
        };
        agent.Harness = harness;
        preset.Agents.Add(agent);
        var workflow = new WorkflowDefinition
        {
            Id = Guid.NewGuid(),
            PresetId = preset.Id,
            Key = "flow",
            Preset = preset
        };
        var step = new WorkflowStepDefinition
        {
            Id = Guid.NewGuid(),
            WorkflowId = workflow.Id,
            Position = 1,
            Type = WorkflowNodeType.Agent,
            ReferenceKey = agent.Key,
            DisplayName = agent.Name,
            InputMappingJson = "{}",
            Workflow = workflow
        };
        workflow.Steps.Add(step);
        preset.Workflow = workflow;
        return preset;
    }

    private sealed class StubRuntimeResolver(IAgentRuntime runtime) : IAgentRuntimeResolver
    {
        public IAgentRuntime Resolve(string providerKey) => runtime;
    }

    private sealed class RecordingAgentRuntime(string providerKey, string output) : IAgentRuntime
    {
        public string ProviderKey => providerKey;
        public string? LastInput { get; private set; }
        public string? LastModel { get; private set; }
        public double? LastTemperature { get; private set; }
        public string? LastApiKey { get; private set; }

        public Task<string> ExecuteAsync(
            AgentDefinition definition,
            string input,
            string model,
            double? temperature,
            string apiKey,
            CancellationToken cancellationToken)
        {
            LastInput = input;
            LastModel = model;
            LastTemperature = temperature;
            LastApiKey = apiKey;
            return Task.FromResult(output);
        }
    }
}
