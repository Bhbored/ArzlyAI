using ArzlyAI.Application.Mappers.Presets;
using ArzlyAI.Application.Repositories.Presets;
using ArzlyAI.Application.Services.Presets;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.Extensions.Logging.Abstractions;

namespace ArzlyAI.Tests;

public sealed class PresetServiceTests
{
    [Fact]
    public async Task GetByKeyAsync_ReturnsEditableModelSettingsAndLockedSystemPrompt()
    {
        var preset = CreatePreset();
        var service = new PresetService(
            new PresetRepositoryStub(preset),
            new PresetMapper(new ProviderModelCapabilityPolicy()),
            NullLogger<PresetService>.Instance);

        var response = await service.GetByKeyAsync(preset.Key, CancellationToken.None);

        Assert.NotNull(response);
        Assert.False(response.Agents[0].IsSystemPromptEditable);
        Assert.True(response.Agents[0].ModelConfiguration.IsModelEditable);
        Assert.True(response.Agents[0].ModelConfiguration.IsTemperatureEditable);
        Assert.Equal(2, response.Workflow.Nodes.Count);
        Assert.Single(response.Workflow.Connections);
    }

    [Fact]
    public async Task GetByKeyAsync_WhenDefaultModelHasNoTemperature_AllowsCapableOverrideModels()
    {
        var preset = CreatePreset("gpt-5-mini");
        var service = new PresetService(
            new PresetRepositoryStub(preset),
            new PresetMapper(new ProviderModelCapabilityPolicy()),
            NullLogger<PresetService>.Instance);

        var response = await service.GetByKeyAsync(preset.Key, CancellationToken.None);

        Assert.NotNull(response);
        Assert.True(response.Agents[0].ModelConfiguration.IsTemperatureEditable);
    }

    private static PresetDefinition CreatePreset(string modelKey = "gpt-4.1-mini")
    {
        var provider = new ProviderDefinition { Id = Guid.NewGuid(), Key = "openai", DisplayName = "OpenAI" };
        var model = new ModelDefinition { Id = Guid.NewGuid(), ProviderId = provider.Id, Key = modelKey, DisplayName = modelKey, Provider = provider };
        provider.Models.Add(model);
        var preset = new PresetDefinition { Id = Guid.NewGuid(), Key = "preset", Name = "Preset", Description = "Description", Version = 1, Status = PresetPublicationStatus.Published, UpdatedAtUtc = DateTimeOffset.UtcNow };
        var agent = new AgentDefinition
        {
            Id = Guid.NewGuid(), PresetId = preset.Id, ModelId = model.Id, Key = "writer", Name = "Writer",
            Instructions = "Locked", RuntimeType = AgentRuntimeType.Model, DefaultTemperature = .7,
            MinimumTemperature = 0, MaximumTemperature = 1, AllowModelOverride = true,
            AllowTemperatureOverride = true, Model = model, Preset = preset
        };
        var harness = new AgentHarnessDefinition { Id = Guid.NewGuid(), AgentId = agent.Id, Agent = agent, MaxIterations = 3 };
        agent.Harness = harness;
        preset.Agents.Add(agent);
        var workflow = new WorkflowDefinition { Id = Guid.NewGuid(), PresetId = preset.Id, Key = "flow", Preset = preset };
        var first = new WorkflowStepDefinition { Id = Guid.NewGuid(), WorkflowId = workflow.Id, Position = 1, Type = WorkflowNodeType.Agent, ReferenceKey = agent.Key, DisplayName = agent.Name, InputMappingJson = "{}", Workflow = workflow };
        var second = new WorkflowStepDefinition { Id = Guid.NewGuid(), WorkflowId = workflow.Id, Position = 2, Type = WorkflowNodeType.HumanApproval, ReferenceKey = "approval", DisplayName = "Approval", InputMappingJson = "{}", Workflow = workflow };
        workflow.Steps.Add(first); workflow.Steps.Add(second);
        workflow.Connections.Add(new WorkflowConnectionDefinition { Id = Guid.NewGuid(), WorkflowId = workflow.Id, SourceStepId = first.Id, TargetStepId = second.Id, Workflow = workflow });
        preset.Workflow = workflow;
        return preset;
    }

    private sealed class PresetRepositoryStub(PresetDefinition preset) : IPresetRepository
    {
        public Task<IReadOnlyList<PresetDefinition>> ListAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<PresetDefinition>>([preset]);
        public Task<PresetDefinition?> GetByIdAsync(Guid id, CancellationToken cancellationToken) =>
            Task.FromResult<PresetDefinition?>(id == preset.Id ? preset : null);
        public Task AddAsync(PresetDefinition entity, CancellationToken cancellationToken) => Task.CompletedTask;
        public Task UpdateAsync(PresetDefinition entity, CancellationToken cancellationToken) => Task.CompletedTask;
        public Task DeleteAsync(PresetDefinition entity, CancellationToken cancellationToken) => Task.CompletedTask;
        public Task<IReadOnlyList<PresetDefinition>> ListPublishedAsync(CancellationToken cancellationToken) => Task.FromResult<IReadOnlyList<PresetDefinition>>([preset]);
        public Task<PresetDefinition?> GetPublishedByKeyAsync(string key, CancellationToken cancellationToken) => Task.FromResult<PresetDefinition?>(key == preset.Key ? preset : null);
    }
}
