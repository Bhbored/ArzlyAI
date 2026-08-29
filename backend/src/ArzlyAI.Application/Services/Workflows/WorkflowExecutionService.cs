using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Mappers.Workflows;
using ArzlyAI.Application.Models;
using ArzlyAI.Application.Repositories.Workflows;
using ArzlyAI.Application.Security;
using ArzlyAI.Application.Services.Notifications;
using ArzlyAI.Application.Services.Presets;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Domain.Enums;
using ArzlyAI.Domain.Presets;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Workflows;

public sealed class WorkflowExecutionService(
    IPresetService presetService,
    IWorkflowRunRepository runs,
    ICredentialEnvelopeProtector credentialsProtector,
    IWorkflowGraphPlanner graphPlanner,
    IWorkflowInputMapper inputMapper,
    IEnumerable<IWorkflowNodeHandler> nodeHandlers,
    IWorkflowRealtimeNotifier realtime,
    INotificationService notifications,
    IWorkflowRunMapper mapper,
    ILogger<WorkflowExecutionService> logger) : IWorkflowExecutionService
{
    public async Task<WorkflowRunResponse> StartAsync(
        StartWorkflowRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowExecutionService.Start");
        logger.LogInformation("Starting workflow for preset {PresetKey}", request.PresetKey);
        var preset = await presetService.GetEntityByKeyAsync(request.PresetKey, cancellationToken)
            ?? throw new KeyNotFoundException($"Preset '{request.PresetKey}' was not found.");
        var plan = graphPlanner.Plan(preset.Workflow);
        ValidateOverrides(preset, request.AgentOverrides);
        var credentials = credentialsProtector.Decrypt(request.Credentials);
        var run = CreateRun(preset, request);
        await runs.AddAsync(run, cancellationToken);

        await ExecutePlanAsync(preset, plan, run, credentials, 0, cancellationToken);
        return mapper.ToResponse(run);
    }

    public async Task<WorkflowRunResponse?> GetAsync(Guid runId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowExecutionService.Get");
        var run = await runs.GetAsync(runId, cancellationToken);
        if (run is null) logger.LogWarning("Workflow run {RunId} was not found or expired", runId);
        return run is null ? null : mapper.ToResponse(run);
    }

    public async Task<WorkflowRunResponse> SubmitApprovalAsync(
        Guid runId,
        SubmitApprovalRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("WorkflowExecutionService.SubmitApproval");
        logger.LogInformation("Processing {Decision} for workflow run {RunId}", request.Decision, runId);
        var run = await runs.GetAsync(runId, cancellationToken)
            ?? throw new KeyNotFoundException($"Workflow run '{runId}' was not found or expired.");
        if (run.Status != WorkflowRunStatus.WaitingForApproval || run.PendingApprovalNodeId is null)
            throw new InvalidOperationException("This workflow is not waiting for approval.");

        var preset = await presetService.GetEntityByKeyAsync(run.PresetKey, cancellationToken)
            ?? throw new KeyNotFoundException($"Preset '{run.PresetKey}' was not found.");
        var plan = graphPlanner.Plan(preset.Workflow);
        var approvalIndex = FindStepIndex(plan, run.PendingApprovalNodeId.Value);
        var approvalNode = run.Nodes.Single(node => node.NodeId == run.PendingApprovalNodeId.Value);

        if (request.Decision == ApprovalDecision.Reject)
        {
            run.PendingApprovalNodeId = null;
            run.Status = WorkflowRunStatus.Cancelled;
            await SetStatusAsync(
                run, approvalNode, WorkflowNodeStatus.Completed, "Content rejected.", cancellationToken);
            logger.LogWarning("Workflow run {RunId} was rejected", run.Id);
            return mapper.ToResponse(run);
        }

        if (request.Decision == ApprovalDecision.Edit)
        {
            var feedback = string.IsNullOrWhiteSpace(request.EditedContent)
                ? throw new ArgumentException("Edit feedback is required.")
                : request.EditedContent.Trim();
            var regenerationCredentials = request.Credentials is null
                ? throw new ArgumentException("Fresh model credentials are required to regenerate content.")
                : credentialsProtector.Decrypt(request.Credentials);
            var writerIndex = FindRegenerationAgentIndex(preset.Workflow, plan, approvalIndex);
            var writerStep = plan[writerIndex];

            run.RegenerationFeedback[writerStep.Id] = feedback;
            run.PendingApprovalNodeId = null;
            run.Status = WorkflowRunStatus.Running;
            run.FinalResponse = null;
            await ResetForRegenerationAsync(
                run, plan, writerIndex, cancellationToken);
            await ExecutePlanAsync(
                preset, plan, run, regenerationCredentials, writerIndex, cancellationToken);
            return mapper.ToResponse(run);
        }

        var approvedContent = !string.IsNullOrWhiteSpace(run.CurrentContent)
            ? run.CurrentContent
            : throw new InvalidOperationException("The approval node has no content to approve.");
        run.ApprovedOutputs[approvalNode.NodeId] = approvedContent;
        run.PendingApprovalNodeId = null;
        await SetStatusAsync(
            run, approvalNode, WorkflowNodeStatus.Completed, "Content approved.", cancellationToken);

        IReadOnlyDictionary<string, string> credentials = new Dictionary<string, string>();
        if (approvalIndex + 1 < plan.Count)
        {
            credentials = request.Credentials is null
                ? throw new ArgumentException("Fresh credentials are required after approval.")
                : credentialsProtector.Decrypt(request.Credentials);
        }

        run.Status = WorkflowRunStatus.Running;
        await ExecutePlanAsync(
            preset, plan, run, credentials, approvalIndex + 1, cancellationToken);
        return mapper.ToResponse(run);
    }

    private async Task ExecutePlanAsync(
        PresetDefinition preset,
        IReadOnlyList<WorkflowStepDefinition> plan,
        WorkflowRun run,
        IReadOnlyDictionary<string, string> credentials,
        int startIndex,
        CancellationToken cancellationToken)
    {
        for (var index = startIndex; index < plan.Count; index++)
        {
            var step = plan[index];
            var node = run.Nodes.Single(candidate => candidate.NodeId == step.Id);
            var handler = ResolveHandler(step.Type);
            var mappedInputs = inputMapper.Map(step, plan, run);
            var agentOverride = run.AgentOverrides.SingleOrDefault(
                candidate => candidate.AgentKey == step.ReferenceKey);
            var context = new WorkflowNodeExecutionContext(
                preset, step, run, mappedInputs, credentials, agentOverride);

            if (handler.StartsRunning)
                await SetStatusAsync(
                    run, node, WorkflowNodeStatus.Running, handler.RunningMessage(step), cancellationToken);

            try
            {
                var result = await handler.ExecuteAsync(context, cancellationToken);
                node.Output = result.Output;
                if (result.PausesWorkflow)
                {
                    run.Status = WorkflowRunStatus.WaitingForApproval;
                    await SetStatusAsync(run, node, result.Status, result.Message, cancellationToken);
                    await notifications.WorkflowNeedsApprovalAsync(run.Id, preset.Name, cancellationToken);
                    logger.LogInformation("Workflow run {RunId} is waiting for approval", run.Id);
                    return;
                }

                await SetStatusAsync(run, node, result.Status, result.Message, cancellationToken);
            }
            catch (Exception exception)
            {
                node.Error = exception.Message;
                run.Status = WorkflowRunStatus.Failed;
                await SetStatusAsync(
                    run, node, WorkflowNodeStatus.Failed, $"{step.DisplayName} failed.", cancellationToken);
                logger.LogError(
                    exception,
                    "Workflow run {RunId} failed at node {NodeKey}",
                    run.Id,
                    step.ReferenceKey);
                throw;
            }
        }

        run.Status = WorkflowRunStatus.Completed;
        run.FinalResponse = ResolveFinalResponse(plan, run);
        await runs.UpdateAsync(run, cancellationToken);
        await notifications.WorkflowCompletedAsync(run.Id, preset.Name, cancellationToken);
        logger.LogInformation("Workflow run {RunId} completed", run.Id);
    }

    private IWorkflowNodeHandler ResolveHandler(WorkflowNodeType nodeType) =>
        nodeHandlers.SingleOrDefault(handler => handler.NodeType == nodeType)
        ?? throw new InvalidOperationException($"No workflow node handler is installed for '{nodeType}'.");

    private static WorkflowRun CreateRun(PresetDefinition preset, StartWorkflowRequest request) => new()
    {
        Id = Guid.NewGuid(),
        PresetKey = preset.Key,
        Status = WorkflowRunStatus.Running,
        ExpiresAtUtc = DateTimeOffset.UtcNow.AddMinutes(30),
        Inputs = new Dictionary<string, string>(request.Inputs, StringComparer.Ordinal),
        AgentOverrides = request.AgentOverrides.ToList(),
        Nodes = preset.Workflow.Steps.OrderBy(step => step.Position).Select(step => new WorkflowNodeRun
        {
            NodeId = step.Id,
            NodeKey = step.ReferenceKey,
            DisplayName = step.DisplayName,
            Type = step.Type,
            Status = WorkflowNodeStatus.Idle
        }).ToList()
    };

    private async Task SetStatusAsync(
        WorkflowRun run,
        WorkflowNodeRun node,
        WorkflowNodeStatus status,
        string message,
        CancellationToken cancellationToken)
    {
        node.Status = status;
        await runs.UpdateAsync(run, cancellationToken);
        await realtime.NodeChangedAsync(new WorkflowNodeChangedEvent(
            run.Id,
            node.NodeId,
            node.NodeKey,
            status.ToString(),
            status == WorkflowNodeStatus.Running,
            message,
            DateTimeOffset.UtcNow), cancellationToken);
    }

    private static int FindStepIndex(IReadOnlyList<WorkflowStepDefinition> plan, Guid stepId)
    {
        for (var index = 0; index < plan.Count; index++)
            if (plan[index].Id == stepId)
                return index;
        throw new InvalidOperationException("The pending approval node is not in the workflow graph.");
    }

    private static int FindRegenerationAgentIndex(
        WorkflowDefinition workflow,
        IReadOnlyList<WorkflowStepDefinition> plan,
        int approvalIndex)
    {
        var steps = plan.ToDictionary(step => step.Id);
        var incoming = workflow.Connections
            .GroupBy(connection => connection.TargetStepId)
            .ToDictionary(
                group => group.Key,
                group => group.Select(connection => connection.SourceStepId).ToList());
        var frontier = new Queue<Guid>([plan[approvalIndex].Id]);
        var visited = new HashSet<Guid>();
        var candidates = new List<Guid>();

        while (frontier.Count > 0 && candidates.Count == 0)
        {
            var levelCount = frontier.Count;
            for (var index = 0; index < levelCount; index++)
            {
                var current = frontier.Dequeue();
                if (!visited.Add(current) || !incoming.TryGetValue(current, out var sources)) continue;
                foreach (var sourceId in sources)
                {
                    if (!steps.TryGetValue(sourceId, out var source)) continue;
                    if (source.Type == WorkflowNodeType.Agent)
                        candidates.Add(sourceId);
                    else
                        frontier.Enqueue(sourceId);
                }
            }
        }

        if (candidates.Distinct().Count() != 1)
            throw new InvalidOperationException(
                "An edit requires exactly one upstream agent to regenerate the approval content.");
        return FindStepIndex(plan, candidates[0]);
    }

    private async Task ResetForRegenerationAsync(
        WorkflowRun run,
        IReadOnlyList<WorkflowStepDefinition> plan,
        int startIndex,
        CancellationToken cancellationToken)
    {
        for (var index = startIndex; index < plan.Count; index++)
        {
            var node = run.Nodes.Single(candidate => candidate.NodeId == plan[index].Id);
            var statusChanged = node.Status != WorkflowNodeStatus.Idle;
            node.Output = null;
            node.Error = null;
            run.ApprovedOutputs.Remove(node.NodeId);
            if (statusChanged)
                await SetStatusAsync(
                    run, node, WorkflowNodeStatus.Idle, $"{node.DisplayName} reset for regeneration.", cancellationToken);
        }
    }

    private static string? ResolveFinalResponse(
        IReadOnlyList<WorkflowStepDefinition> plan,
        WorkflowRun run)
    {
        var finalStep = plan[^1];
        var finalNode = run.Nodes.Single(node => node.NodeId == finalStep.Id);
        return finalNode.Type == WorkflowNodeType.HumanApproval
            ? run.ApprovedOutputs.GetValueOrDefault(finalNode.NodeId)
            : finalNode.Output;
    }

    private static void ValidateOverrides(
        PresetDefinition preset,
        IReadOnlyList<AgentOverrideRequest> overrides)
    {
        var duplicate = overrides.GroupBy(item => item.AgentKey, StringComparer.Ordinal)
            .FirstOrDefault(group => group.Count() > 1);
        if (duplicate is not null)
            throw new ArgumentException($"Agent override '{duplicate.Key}' was supplied more than once.");

        var knownAgents = preset.Agents.Select(agent => agent.Key).ToHashSet(StringComparer.Ordinal);
        var unknown = overrides.FirstOrDefault(item => !knownAgents.Contains(item.AgentKey));
        if (unknown is not null)
            throw new ArgumentException($"Agent '{unknown.AgentKey}' is not defined by the preset.");
    }
}
