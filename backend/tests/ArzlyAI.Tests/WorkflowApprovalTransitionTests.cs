using ArzlyAI.Application.DTOs.Presets;
using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Mappers.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Repositories.Workflows;
using ArzlyAI.Application.Security;
using ArzlyAI.Application.Services.Presets;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Application.Services.Workflows;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.Extensions.Logging.Abstractions;

namespace ArzlyAI.Tests;

public sealed class WorkflowApprovalTransitionTests
{
    [Fact]
    public async Task SubmitApprovalAsync_WhenEdit_RegeneratesAndWaitsWithoutIntegration()
    {
        var fixture = CreateFixture();
        var started = await fixture.Service.StartAsync(StartRequest(), CancellationToken.None);

        var result = await fixture.Service.SubmitApprovalAsync(
            started.RunId,
            new SubmitApprovalRequest(ApprovalDecision.Edit, "Use a stronger opening.", Envelope()),
            CancellationToken.None);

        Assert.Equal(nameof(WorkflowRunStatus.WaitingForApproval), result.Status);
        Assert.Equal("Regenerated draft", result.Approval?.OriginalContent);
        Assert.Equal("Regenerated draft", result.Approval?.CurrentContent);
        Assert.Equal(nameof(WorkflowNodeStatus.Completed), result.Nodes[0].Status);
        Assert.Equal(nameof(WorkflowNodeStatus.WaitingForApproval), result.Nodes[1].Status);
        Assert.All(result.Nodes.Skip(2), node => Assert.Equal(nameof(WorkflowNodeStatus.Idle), node.Status));
        Assert.Equal(0, fixture.Integration.ExecutionCount);
        Assert.Contains(fixture.Realtime.Events, message =>
            message.NodeKey == "writer" && message.Status == nameof(WorkflowNodeStatus.Running));
        Assert.Contains(fixture.Realtime.Events, message =>
            message.NodeKey == "approval" && message.Status == nameof(WorkflowNodeStatus.WaitingForApproval));
    }

    [Fact]
    public async Task SubmitApprovalAsync_WhenReject_CancelsWithoutCredentialsOrIntegration()
    {
        var fixture = CreateFixture();
        var started = await fixture.Service.StartAsync(StartRequest(), CancellationToken.None);

        var result = await fixture.Service.SubmitApprovalAsync(
            started.RunId,
            new SubmitApprovalRequest(ApprovalDecision.Reject, null, null),
            CancellationToken.None);

        Assert.Equal(nameof(WorkflowRunStatus.Cancelled), result.Status);
        Assert.Equal(0, fixture.Integration.ExecutionCount);
        Assert.All(result.Nodes.Skip(2), node => Assert.Equal(nameof(WorkflowNodeStatus.Idle), node.Status));
    }

    [Fact]
    public async Task SubmitApprovalAsync_WhenAccept_ExecutesDownstreamIntegration()
    {
        var fixture = CreateFixture();
        var started = await fixture.Service.StartAsync(StartRequest(), CancellationToken.None);

        var result = await fixture.Service.SubmitApprovalAsync(
            started.RunId,
            new SubmitApprovalRequest(ApprovalDecision.Accept, null, Envelope()),
            CancellationToken.None);

        Assert.Equal(nameof(WorkflowRunStatus.Completed), result.Status);
        Assert.Equal("post-id", result.FinalResponse);
        Assert.Equal(1, fixture.Integration.ExecutionCount);
        Assert.All(result.Nodes, node => Assert.Equal(nameof(WorkflowNodeStatus.Completed), node.Status));
    }

    [Fact]
    public async Task StartAsync_WhenProviderChangesWithoutModel_RejectsAmbiguousOverride()
    {
        var fixture = CreateFixture();
        var request = StartRequest(
            [new AgentOverrideRequest("writer", "anthropic", null, null)]);

        var exception = await Assert.ThrowsAsync<ArgumentException>(() =>
            fixture.Service.StartAsync(request, CancellationToken.None));

        Assert.Contains("model override is required", exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task StartAsync_WhenProviderAndModelDoNotMatch_RejectsOverride()
    {
        var fixture = CreateFixture();
        var request = StartRequest(
            [new AgentOverrideRequest("writer", "gemini", "deepseek-chat", null)]);

        var exception = await Assert.ThrowsAsync<ArgumentException>(() =>
            fixture.Service.StartAsync(request, CancellationToken.None));

        Assert.Contains("does not belong", exception.Message, StringComparison.OrdinalIgnoreCase);
    }

    private static Fixture CreateFixture()
    {
        var preset = CreatePreset();
        var repository = new RunRepositoryStub();
        var realtime = new RealtimeStub();
        var integration = new IntegrationHandlerStub();
        IWorkflowNodeHandler[] handlers =
        [
            new AgentHandlerStub(),
            new HumanApprovalWorkflowNodeHandler(),
            integration
        ];
        var service = new WorkflowExecutionService(
            new PresetServiceStub(preset),
            repository,
            new CredentialsStub(),
            new WorkflowGraphPlanner(),
            new WorkflowInputMapper(),
            handlers,
            realtime,
            new WorkflowRunMapper(),
            new ProviderModelCapabilityPolicy(),
            NullLogger<WorkflowExecutionService>.Instance);
        return new Fixture(service, integration, realtime);
    }

    private static PresetDefinition CreatePreset()
    {
        var preset = new PresetDefinition
        {
            Id = Guid.NewGuid(),
            Key = "test-preset",
            Name = "Test preset",
            Description = "Test",
            Version = 1,
            Status = PresetPublicationStatus.Published
        };
        var provider = new ProviderDefinition
        {
            Id = Guid.NewGuid(),
            Key = "openai",
            DisplayName = "OpenAI"
        };
        var model = new ModelDefinition
        {
            Id = Guid.NewGuid(),
            ProviderId = provider.Id,
            Provider = provider,
            Key = "gpt-5-mini",
            DisplayName = "GPT-5 mini"
        };
        provider.Models.Add(model);
        var agent = new AgentDefinition
        {
            Id = Guid.NewGuid(),
            PresetId = preset.Id,
            Preset = preset,
            ModelId = model.Id,
            Model = model,
            Key = "writer",
            Name = "Writer",
            Instructions = "Write",
            RuntimeType = AgentRuntimeType.Model,
            AllowModelOverride = true,
            AllowTemperatureOverride = true
        };
        agent.Harness = new AgentHarnessDefinition
        {
            Id = Guid.NewGuid(),
            AgentId = agent.Id,
            Agent = agent,
            MaxIterations = 3
        };
        preset.Agents.Add(agent);
        var workflow = new WorkflowDefinition
        {
            Id = Guid.NewGuid(),
            PresetId = preset.Id,
            Key = "generate-review-publish",
            Preset = preset
        };
        var writer = Step(workflow, 0, WorkflowNodeType.Agent, "writer", "{\"topic\":\"$.inputs.topic\"}");
        var approval = Step(workflow, 1, WorkflowNodeType.HumanApproval, "approval", "{\"content\":\"$.steps[0].output\"}");
        var publisher = Step(workflow, 2, WorkflowNodeType.Agent, "publisher", "{\"content\":\"$.steps[1].approvedOutput\"}");
        var integration = Step(workflow, 3, WorkflowNodeType.Integration, "integration", "{\"text\":\"$.steps[2].output\"}");
        workflow.Steps.Add(writer);
        workflow.Steps.Add(approval);
        workflow.Steps.Add(publisher);
        workflow.Steps.Add(integration);
        workflow.Connections.Add(Connection(workflow, writer, approval));
        workflow.Connections.Add(Connection(workflow, approval, publisher));
        workflow.Connections.Add(Connection(workflow, publisher, integration));
        preset.Workflow = workflow;
        return preset;
    }

    private static WorkflowStepDefinition Step(
        WorkflowDefinition workflow,
        int position,
        WorkflowNodeType type,
        string key,
        string mapping) => new()
    {
        Id = Guid.NewGuid(),
        WorkflowId = workflow.Id,
        Position = position,
        Type = type,
        ReferenceKey = key,
        DisplayName = key,
        InputMappingJson = mapping,
        Workflow = workflow
    };

    private static WorkflowConnectionDefinition Connection(
        WorkflowDefinition workflow,
        WorkflowStepDefinition source,
        WorkflowStepDefinition target) => new()
    {
        Id = Guid.NewGuid(),
        WorkflowId = workflow.Id,
        SourceStepId = source.Id,
        TargetStepId = target.Id,
        Workflow = workflow
    };

    private static StartWorkflowRequest StartRequest(
        IReadOnlyList<AgentOverrideRequest>? overrides = null) => new(
        "test-preset",
        new Dictionary<string, string> { ["topic"] = "AI" },
        overrides ?? [],
        Envelope());

    private static CredentialEnvelope Envelope() => new(
        "key", Guid.NewGuid().ToString(), long.MaxValue, "key", "nonce", "cipher", "tag");

    private sealed record Fixture(
        WorkflowExecutionService Service,
        IntegrationHandlerStub Integration,
        RealtimeStub Realtime);

    private sealed class AgentHandlerStub : IWorkflowNodeHandler
    {
        public WorkflowNodeType NodeType => WorkflowNodeType.Agent;
        public bool StartsRunning => true;
        public string RunningMessage(WorkflowStepDefinition step) => "running";

        public Task<WorkflowNodeExecutionResult> ExecuteAsync(
            WorkflowNodeExecutionContext context,
            CancellationToken cancellationToken)
        {
            var output = context.Step.ReferenceKey == "publisher"
                ? context.Inputs["content"]
                : context.Inputs.ContainsKey("editFeedback") ? "Regenerated draft" : "Original draft";
            return Task.FromResult(new WorkflowNodeExecutionResult(
                output, WorkflowNodeStatus.Completed, "completed"));
        }
    }

    private sealed class IntegrationHandlerStub : IWorkflowNodeHandler
    {
        public int ExecutionCount { get; private set; }
        public WorkflowNodeType NodeType => WorkflowNodeType.Integration;
        public bool StartsRunning => true;
        public string RunningMessage(WorkflowStepDefinition step) => "running";

        public Task<WorkflowNodeExecutionResult> ExecuteAsync(
            WorkflowNodeExecutionContext context,
            CancellationToken cancellationToken)
        {
            ExecutionCount++;
            return Task.FromResult(new WorkflowNodeExecutionResult(
                "post-id", WorkflowNodeStatus.Completed, "completed"));
        }
    }

    private sealed class RunRepositoryStub : IWorkflowRunRepository
    {
        private WorkflowRun? run;
        public Task AddAsync(WorkflowRun value, CancellationToken cancellationToken)
        {
            run = value;
            return Task.CompletedTask;
        }
        public Task<WorkflowRun?> GetAsync(Guid runId, CancellationToken cancellationToken) =>
            Task.FromResult(run?.Id == runId ? run : null);
        public Task UpdateAsync(WorkflowRun value, CancellationToken cancellationToken)
        {
            run = value;
            return Task.CompletedTask;
        }
    }

    private sealed class PresetServiceStub(PresetDefinition preset) : IPresetService
    {
        public Task<IReadOnlyList<PresetSummaryResponse>> GetAllAsync(CancellationToken cancellationToken) =>
            throw new NotSupportedException();
        public Task<PresetDetailsResponse?> GetByKeyAsync(string key, CancellationToken cancellationToken) =>
            throw new NotSupportedException();
        public Task<PresetDefinition?> GetEntityByKeyAsync(string key, CancellationToken cancellationToken) =>
            Task.FromResult<PresetDefinition?>(key == preset.Key ? preset : null);
    }

    private sealed class CredentialsStub : ICredentialEnvelopeProtector
    {
        public EncryptionKeyDescriptor DescribeKey() => throw new NotSupportedException();
        public IReadOnlyDictionary<string, string> Decrypt(CredentialEnvelope envelope) =>
            new Dictionary<string, string> { ["openai.apiKey"] = "test", ["integration.token"] = "test" };
    }

    private sealed class RealtimeStub : IWorkflowRealtimeNotifier
    {
        public List<WorkflowNodeChangedEvent> Events { get; } = [];
        public Task NodeChangedAsync(WorkflowNodeChangedEvent message, CancellationToken cancellationToken)
        {
            Events.Add(message);
            return Task.CompletedTask;
        }
    }
}
