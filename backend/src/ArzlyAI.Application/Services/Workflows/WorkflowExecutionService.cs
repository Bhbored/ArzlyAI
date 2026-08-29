using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Integrations;
using ArzlyAI.Application.Mappers.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Repositories.Workflows;
using ArzlyAI.Application.Security;
using ArzlyAI.Application.Services.Agents;
using ArzlyAI.Application.Services.Notifications;
using ArzlyAI.Application.Services.Presets;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows;

public sealed class WorkflowExecutionService(
    IPresetService presetService,
    IWorkflowRunRepository runs,
    ICredentialEnvelopeProtector credentialsProtector,
    IAgentRuntime agentRuntime,
    IEnumerable<IIntegrationHandler> integrationHandlers,
    IWorkflowRealtimeNotifier realtime,
    INotificationService notifications,
    IWorkflowRunMapper mapper,
    ILogger<WorkflowExecutionService> logger) : IWorkflowExecutionService
{
    public async Task<WorkflowRunResponse> StartAsync(StartWorkflowRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowExecutionService.Start");
        logger.LogInformation("Starting workflow for preset {PresetKey}", request.PresetKey);
        var preset = await presetService.GetEntityByKeyAsync(request.PresetKey, cancellationToken)
            ?? throw new KeyNotFoundException($"Preset '{request.PresetKey}' was not found.");
        var credentials = credentialsProtector.Decrypt(request.Credentials);
        var run = CreateRun(preset);
        await runs.AddAsync(run, cancellationToken);

        var firstAgentStep = preset.Workflow.Steps.OrderBy(x => x.Position)
            .First(x => x.Type == WorkflowNodeType.Agent);
        var firstAgent = preset.Agents.Single(x => x.Key == firstAgentStep.ReferenceKey);
        var input = Required(request.Inputs, "topic");
        var overrideRequest = request.AgentOverrides.SingleOrDefault(x => x.AgentKey == firstAgent.Key);
        var model = ResolveModel(firstAgent, overrideRequest?.Model);
        var temperature = ResolveTemperature(firstAgent, overrideRequest?.Temperature);
        var node = run.Nodes.Single(x => x.NodeId == firstAgentStep.Id);

        await SetStatus(run, node, WorkflowNodeStatus.Running, "Agent is thinking.", cancellationToken);
        try
        {
            node.Output = await agentRuntime.ExecuteAsync(firstAgent, input, model, temperature,
                Required(credentials, "openai.apiKey"), cancellationToken);
            run.OriginalContent = node.Output;
            run.CurrentContent = node.Output;
            await SetStatus(run, node, WorkflowNodeStatus.Completed, "Draft generated.", cancellationToken);

            var approval = preset.Workflow.Steps.Single(x => x.Type == WorkflowNodeType.HumanApproval);
            var approvalNode = run.Nodes.Single(x => x.NodeId == approval.Id);
            run.Status = WorkflowRunStatus.WaitingForApproval;
            await SetStatus(run, approvalNode, WorkflowNodeStatus.WaitingForApproval,
                "Review, edit, accept, or reject the generated content.", cancellationToken);
            await notifications.WorkflowNeedsApprovalAsync(run.Id, preset.Name, cancellationToken);
            logger.LogInformation("Workflow run {RunId} is waiting for approval", run.Id);
            return mapper.ToResponse(run);
        }
        catch (Exception exception)
        {
            node.Error = exception.Message;
            run.Status = WorkflowRunStatus.Failed;
            await SetStatus(run, node, WorkflowNodeStatus.Failed, "Agent execution failed.", cancellationToken);
            logger.LogError(exception, "Workflow run {RunId} failed during agent execution", run.Id);
            throw;
        }
    }

    public async Task<WorkflowRunResponse?> GetAsync(Guid runId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowExecutionService.Get");
        var run = await runs.GetAsync(runId, cancellationToken);
        if (run is null) logger.LogWarning("Workflow run {RunId} was not found or expired", runId);
        return run is null ? null : mapper.ToResponse(run);
    }

    public async Task<WorkflowRunResponse> SubmitApprovalAsync(
        Guid runId, SubmitApprovalRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowExecutionService.SubmitApproval");
        logger.LogInformation("Processing {Decision} for workflow run {RunId}", request.Decision, runId);
        var run = await runs.GetAsync(runId, cancellationToken)
            ?? throw new KeyNotFoundException($"Workflow run '{runId}' was not found or expired.");
        if (run.Status != WorkflowRunStatus.WaitingForApproval)
            throw new InvalidOperationException("This workflow is not waiting for approval.");
        var preset = await presetService.GetEntityByKeyAsync(run.PresetKey, cancellationToken)
            ?? throw new KeyNotFoundException($"Preset '{run.PresetKey}' was not found.");
        var approvalNode = run.Nodes.Single(x => x.Type == WorkflowNodeType.HumanApproval);

        if (request.Decision == ApprovalDecision.Reject)
        {
            run.Status = WorkflowRunStatus.Cancelled;
            await SetStatus(run, approvalNode, WorkflowNodeStatus.Completed, "Content rejected.", cancellationToken);
            await runs.UpdateAsync(run, cancellationToken);
            logger.LogWarning("Workflow run {RunId} was rejected", run.Id);
            return mapper.ToResponse(run);
        }

        if (request.Decision == ApprovalDecision.Edit)
            run.CurrentContent = string.IsNullOrWhiteSpace(request.EditedContent)
                ? throw new ArgumentException("Edited content is required.")
                : request.EditedContent.Trim();

        await SetStatus(run, approvalNode, WorkflowNodeStatus.Completed, "Content approved.", cancellationToken);
        var credentials = request.Credentials is null
            ? throw new ArgumentException("Fresh integration credentials are required after approval.")
            : credentialsProtector.Decrypt(request.Credentials);

        foreach (var step in preset.Workflow.Steps.OrderBy(x => x.Position)
                     .SkipWhile(x => x.Type != WorkflowNodeType.HumanApproval).Skip(1))
        {
            var node = run.Nodes.Single(x => x.NodeId == step.Id);
            await SetStatus(run, node, WorkflowNodeStatus.Running, $"{step.DisplayName} is running.", cancellationToken);
            if (step.Type == WorkflowNodeType.Agent)
            {
                var agent = preset.Agents.Single(x => x.Key == step.ReferenceKey);
                node.Output = agent.RuntimeType == AgentRuntimeType.Passthrough
                    ? run.CurrentContent
                    : await agentRuntime.ExecuteAsync(agent, run.CurrentContent!, agent.Model.Key,
                        agent.DefaultTemperature, Required(credentials, "openai.apiKey"), cancellationToken);
                run.CurrentContent = node.Output;
            }
            else if (step.Type == WorkflowNodeType.Integration)
            {
                var handler = integrationHandlers.SingleOrDefault(x => x.Key == step.ReferenceKey)
                    ?? throw new InvalidOperationException($"No handler is installed for '{step.ReferenceKey}'.");
                node.Output = await handler.ExecuteAsync(
                    new Dictionary<string, string> { ["text"] = run.CurrentContent! },
                    credentials, cancellationToken);
                run.FinalResponse = node.Output;
            }
            await SetStatus(run, node, WorkflowNodeStatus.Completed, $"{step.DisplayName} completed.", cancellationToken);
        }

        run.Status = WorkflowRunStatus.Completed;
        await runs.UpdateAsync(run, cancellationToken);
        await notifications.WorkflowCompletedAsync(run.Id, preset.Name, cancellationToken);
        logger.LogInformation("Workflow run {RunId} completed", run.Id);
        return mapper.ToResponse(run);
    }

    private static WorkflowRun CreateRun(PresetDefinition preset) => new()
    {
        Id = Guid.NewGuid(), PresetKey = preset.Key, Status = WorkflowRunStatus.Running,
        ExpiresAtUtc = DateTimeOffset.UtcNow.AddMinutes(30),
        Nodes = preset.Workflow.Steps.OrderBy(x => x.Position).Select(x => new WorkflowNodeRun
        {
            NodeId = x.Id, NodeKey = x.ReferenceKey, DisplayName = x.DisplayName,
            Type = x.Type, Status = WorkflowNodeStatus.Idle
        }).ToList()
    };

    private async Task SetStatus(WorkflowRun run, WorkflowNodeRun node, WorkflowNodeStatus status,
        string message, CancellationToken cancellationToken)
    {
        node.Status = status;
        await runs.UpdateAsync(run, cancellationToken);
        await realtime.NodeChangedAsync(new WorkflowNodeChangedEvent(
            run.Id, node.NodeId, node.NodeKey, status.ToString(), status == WorkflowNodeStatus.Running,
            message, DateTimeOffset.UtcNow), cancellationToken);
    }

    private static string ResolveModel(AgentDefinition agent, string? requested)
    {
        if (string.IsNullOrWhiteSpace(requested)) return agent.Model.Key;
        if (!agent.AllowModelOverride) throw new ArgumentException($"Agent '{agent.Key}' does not allow model changes.");
        if (agent.Model.Provider.Models.All(x => x.Key != requested)) throw new ArgumentException($"Model '{requested}' is not allowed.");
        return requested;
    }

    private static double ResolveTemperature(AgentDefinition agent, double? requested)
    {
        if (requested is null) return agent.DefaultTemperature;
        if (!agent.AllowTemperatureOverride) throw new ArgumentException($"Agent '{agent.Key}' does not allow temperature changes.");
        if (requested < agent.MinimumTemperature || requested > agent.MaximumTemperature)
            throw new ArgumentOutOfRangeException(nameof(requested));
        return requested.Value;
    }

    private static string Required(IReadOnlyDictionary<string, string> values, string key) =>
        values.TryGetValue(key, out var value) && !string.IsNullOrWhiteSpace(value)
            ? value : throw new ArgumentException($"Required value '{key}' is missing.");

}
