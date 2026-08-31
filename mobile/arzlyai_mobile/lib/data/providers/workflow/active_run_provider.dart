import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception_extensions.dart';
import 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart';
import 'package:arzlyai_mobile/core/workflow/workflow_reconciliation.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/agent_override_request.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/start_workflow_request.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/submit_approval_request.dart';
import 'package:arzlyai_mobile/core/realtime/workflow_hub_client.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/core/enums/workflow_transport_state.dart';
import 'package:arzlyai_mobile/data/providers/workflow/workflow_transport_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run_support.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

part 'active_run_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class ActiveRun extends _$ActiveRun {
  StreamSubscription<WorkflowNodeChanged>? _events;
  DateTime? _lastEventAt;
  var _busy = false;

  @override
  Future<WorkflowRun?> build() async {
    _events ??= ref.read(workflowHubClientProvider).events.listen(_onEvent);
    ref.onDispose(() => _events?.cancel());
    final runId = ref.watch(selectedRunIdProvider);
    if (runId == null) return null;
    return ref.read(workflowRepositoryProvider).getLocalRun(runId);
  }

  Future<void> start(RunConfigState config) async {
    if (_busy) return;
    _busy = true;
    WorkflowInstance? instance;
    final expiryUtc = DateTime.now().toUtc().add(const Duration(minutes: 30));
    try {
      final online = ref.read(internetConnectionProvider);
      final offlineMode = await ref.read(offlineModeProvider.future);
      if (!online || offlineMode) {
        state = AsyncError(
          StateError('Generation requires a network connection'),
          StackTrace.current,
        );
        return;
      }
      final details = await ref.read(presetDetailsProvider.future);
      if (details == null) return;
      final effectiveInputs = config.inputs.isEmpty
          ? <String, String>{'topic': config.topic.trim()}
          : Map<String, String>.from(config.inputs);
      final primaryInput = config.topic.trim().isNotEmpty
          ? config.topic.trim()
          : effectiveInputs.values
                    .where((value) => value.trim().isNotEmpty)
                    .firstOrNull ??
                '';
      final topicError = AppValidators.requiredNonEmpty(primaryInput);
      if (topicError != null) {
        state = AsyncError(ArgumentError(topicError), StackTrace.current);
        return;
      }
      state = const AsyncLoading<WorkflowRun?>();
      final writer = details.configurableWorkflowAgent();
      final overrides = await _buildOverrides(config, details, writer);
      final credentialRepo = ref.read(credentialRepositoryProvider);
      final startKeys = details.workflowStartCredentialKeys(
        overrideProviders: overrides.map((item) => item.provider ?? ''),
      );
      final startCredentials = await credentialRepo.readForEnvelopeKeysWithConnectors(
        startKeys,
      );
      final missingStart = credentialRepo.missingEnvelopeKeys(
        startKeys,
        startCredentials,
      );
      if (missingStart.isNotEmpty) {
        throw StateError('Missing credentials: ${missingStart.join(', ')}');
      }
      final resolved = resolveReceiptWorkflowStart(
        presetKey: details.key,
        inputs: effectiveInputs,
      );
      if (isReceiptWorkflowKey(details.key) && resolved == null) {
        throw StateError('Receipt workflow needs reconfiguration.');
      }
      final startPresetKey = resolved?.presetKey ?? details.key;
      final startInputs = resolved?.inputs ?? effectiveInputs;
      final envelope = await ref
          .read(credentialEnvelopeServiceProvider)
          .encrypt(startCredentials);
      instance = await ref
          .read(workflowRepositoryProvider)
          .createInstance(
            presetKey: startPresetKey,
            presetVersion: details.version,
            name: details.name,
            topic: primaryInput.trim(),
            modelOverridesJson: jsonEncode(
              overrides.map((e) => e.toJson()).toList(),
            ),
          );
      ref
          .read(workflowTransportProvider.notifier)
          .setInFlight(pendingLocalWorkflowId: instance.id);
      final dto = await ref
          .read(workflowServiceProvider)
          .start(
            StartWorkflowRequest(
              presetKey: startPresetKey,
              inputs: startInputs,
              agentOverrides: overrides,
              credentials: envelope,
            ),
          );
      final run = await ref
          .read(workflowRepositoryProvider)
          .persistDto(dto, localWorkflowId: instance.id, expiryUtc: expiryUtc);
      ref.read(selectedRunIdProvider.notifier).update(run.runId);
      _lastEventAt = DateTime.now().toUtc();
      state = AsyncData(run);
      ref.read(workflowTransportProvider.notifier).clear();
      try {
        await ref.read(workflowHubClientProvider).subscribeToRun(run.runId);
      } catch (_) {}
    } catch (e, s) {
      if (isReceiveTimeoutError(e) && instance != null) {
        ref.read(workflowTransportProvider.notifier).setProcessing();
        unawaited(_reconcileAfterStartTimeout(instance.id, expiryUtc));
        return;
      }
      ref.read(workflowTransportProvider.notifier).clear();
      state = AsyncError(e, s);
    } finally {
      _busy = false;
    }
  }

  Future<void> reset() async {
    if (_busy) return;
    ref.read(selectedRunIdProvider.notifier).clear();
    ref.read(workflowTransportProvider.notifier).clear();
    _lastEventAt = null;
    state = const AsyncData(null);
  }

  Future<void> refreshSnapshot() async {
    final current = state.value;
    if (current == null) return;
    if (current.status != WorkflowRunStatus.waitingForApproval) return;
    await _refreshRunSnapshot(current);
  }

  Future<void> recover() async {
    final runId = ref.read(selectedRunIdProvider);
    if (runId == null) return;
    final local = await ref.read(workflowRepositoryProvider).getLocalRun(runId);
    if (local == null) return;
    await _reconcileRun(runId, local.localWorkflowId ?? '', local.expiryUtc);
  }

  Future<void> resumeIfProcessing() async {
    final transport = ref.read(workflowTransportProvider);
    if (!transport.isProcessing &&
        transport.transport != WorkflowTransportState.inFlight) {
      return;
    }
    final runId = ref.read(selectedRunIdProvider);
    if (runId != null) {
      final local = await ref
          .read(workflowRepositoryProvider)
          .getLocalRun(runId);
      if (local != null) {
        await _reconcileRun(
          runId,
          local.localWorkflowId ?? '',
          local.expiryUtc,
        );
      }
      return;
    }
    final localWorkflowId = transport.pendingLocalWorkflowId;
    if (localWorkflowId != null) {
      await _reconcileAfterStartTimeout(localWorkflowId, null);
    }
  }

  Future<void> submitApproval(
    ApprovalDecision decision, {
    String? editedContent,
  }) async {
    if (_busy) return;
    _busy = true;
    final current = state.value;
    WorkflowRun? snapshotBeforeOptimistic;
    try {
      final online = ref.read(internetConnectionProvider);
      final offlineMode = await ref.read(offlineModeProvider.future);
      if (!online || offlineMode) {
        state = AsyncError(
          StateError('Publishing requires a network connection'),
          StackTrace.current,
        );
        return;
      }
      if (current == null) return;
      if (decision == ApprovalDecision.edit) {
        if (AppValidators.requiredNonEmpty(editedContent ?? '') != null) {
          state = AsyncError(
            ArgumentError('Edited content is required'),
            StackTrace.current,
          );
          return;
        }
      }
      snapshotBeforeOptimistic = current;
      final approvalNodeId = _pendingApprovalNodeId(current);
      ref
          .read(workflowTransportProvider.notifier)
          .setInFlight(approval: true, approvalNodeId: approvalNodeId);
      final optimistic = _optimisticApproval(current, decision);
      await ref.read(workflowRepositoryProvider).persistRun(optimistic);
      state = AsyncData(optimistic);
      final credentialRepo = ref.read(credentialRepositoryProvider);
      final request = await _buildApprovalRequest(
        decision: decision,
        current: current,
        credentialRepo: credentialRepo,
        editedContent: editedContent,
      );
      final dto = await ref
          .read(workflowServiceProvider)
          .submitApproval(current.runId, request);
      final localWorkflowId = await _resolveLocalWorkflowId(current);
      final run = await ref
          .read(workflowRepositoryProvider)
          .persistDto(
            dto,
            localWorkflowId: localWorkflowId,
            expiryUtc: current.expiryUtc,
          );
      state = AsyncData(run);
      _applyReconciledRun(run);
    } catch (e, s) {
      if (isReceiveTimeoutError(e) && current != null) {
        ref.read(workflowTransportProvider.notifier).setProcessing();
        unawaited(
          _reconcileRun(
            current.runId,
            current.localWorkflowId ?? '',
            current.expiryUtc,
          ),
        );
        return;
      }
      ref.read(workflowTransportProvider.notifier).clear();
      if (snapshotBeforeOptimistic != null) {
        await ref
            .read(workflowRepositoryProvider)
            .persistRun(snapshotBeforeOptimistic);
      }
      state = AsyncError(e, s);
    } finally {
      _busy = false;
    }
  }

  Future<List<AgentOverrideRequest>> _buildOverrides(
    RunConfigState config,
    PresetDetails details,
    Agent? writer,
  ) async {
    final overrides = <AgentOverrideRequest>[];
    final models = await ref.read(availableProviderModelsProvider.future);
    final repo = ref.read(providerModelRepositoryProvider);
    if (config.agentOverrides.isNotEmpty) {
      for (final entry in config.agentOverrides.entries) {
        final agent = details.agents
            .where((item) => item.key == entry.key)
            .firstOrNull;
        if (agent == null) continue;
        final model = entry.value.model;
        if (model == null) continue;
        final provider = repo.resolveProviderForModel(
          models,
          model,
          configuredProvider: entry.value.provider,
          fallbackProvider: agent.modelConfiguration.provider,
        );
        double? temperature;
        if (agent.modelConfiguration.isTemperatureEditable) {
          final supportsTemperature = repo.modelSupportsTemperature(
            models,
            model,
          );
          if (supportsTemperature == true) {
            temperature = AppValidators.clampTemperature(
              entry.value.temperature ?? agent.modelConfiguration.temperature,
              agent.modelConfiguration.minimumTemperature,
              agent.modelConfiguration.maximumTemperature,
            );
          }
        }
        overrides.add(
          AgentOverrideRequest(
            agentKey: entry.key,
            provider: provider,
            model: model,
            temperature: temperature,
          ),
        );
      }
    } else if (writer != null && writer.modelConfiguration.isModelEditable) {
      final model = config.model ?? writer.modelConfiguration.selectedModel;
      final provider = repo.resolveProviderForModel(
        models,
        model,
        configuredProvider: config.provider,
        fallbackProvider: writer.modelConfiguration.provider,
      );
      double? temperature;
      final supportsTemperature = repo.modelSupportsTemperature(models, model);
      if (writer.modelConfiguration.isTemperatureEditable &&
          supportsTemperature == true) {
        temperature = AppValidators.clampTemperature(
          config.temperature ?? writer.modelConfiguration.temperature,
          writer.modelConfiguration.minimumTemperature,
          writer.modelConfiguration.maximumTemperature,
        );
      }
      overrides.add(
        AgentOverrideRequest(
          agentKey: writer.key,
          provider: provider,
          model: model,
          temperature: temperature,
        ),
      );
    }
    _ensureOverrideProviders(overrides, details, models, repo);
    _ensureStartupAgentOverrides(overrides, details, models, repo);
    return overrides;
  }

  void _ensureOverrideProviders(
    List<AgentOverrideRequest> overrides,
    PresetDetails details,
    List<ProviderModel> models,
    ProviderModelRepository repo,
  ) {
    for (var index = 0; index < overrides.length; index++) {
      final override = overrides[index];
      if (override.provider != null && override.provider!.isNotEmpty) continue;
      final model = override.model;
      if (model == null || model.isEmpty) continue;
      final agent = details.agents
          .where((item) => item.key == override.agentKey)
          .firstOrNull;
      final provider = repo.resolveProviderForModel(
        models,
        model,
        fallbackProvider: agent?.modelConfiguration.provider ?? '',
      );
      if (provider.isEmpty) continue;
      overrides[index] = AgentOverrideRequest(
        agentKey: override.agentKey,
        provider: provider,
        model: override.model,
        temperature: override.temperature,
      );
    }
  }

  void _ensureStartupAgentOverrides(
    List<AgentOverrideRequest> overrides,
    PresetDetails details,
    List<ProviderModel> models,
    ProviderModelRepository repo,
  ) {
    if (overrides.isEmpty) return;
    final configurable = details.configurableWorkflowAgent();
    final template = configurable == null
        ? overrides.first
        : overrides
              .where((item) => item.agentKey == configurable.key)
              .firstOrNull ??
            overrides.first;
    final templateModel = template.model;
    if (templateModel == null || templateModel.isEmpty) return;
    final templateProvider = repo.resolveProviderForModel(
      models,
      templateModel,
      configuredProvider: template.provider,
      fallbackProvider:
          configurable?.modelConfiguration.provider ??
          details.agents
              .where((agent) => agent.key == template.agentKey)
              .firstOrNull
              ?.modelConfiguration
              .provider ??
          '',
    );
    if (templateProvider.isEmpty) return;
    final covered = overrides.map((item) => item.agentKey).toSet();
    for (final agent in details.startupModelAgents()) {
      if (covered.contains(agent.key)) continue;
      double? temperature;
      if (agent.modelConfiguration.isTemperatureEditable) {
        final supportsTemperature = repo.modelSupportsTemperature(
          models,
          templateModel,
        );
        if (supportsTemperature == true) {
          temperature = AppValidators.clampTemperature(
            agent.modelConfiguration.temperature,
            agent.modelConfiguration.minimumTemperature,
            agent.modelConfiguration.maximumTemperature,
          );
        }
      }
      overrides.add(
        AgentOverrideRequest(
          agentKey: agent.key,
          provider: templateProvider,
          model: templateModel,
          temperature: temperature,
        ),
      );
    }
  }

  Future<SubmitApprovalRequest> _buildApprovalRequest({
    required ApprovalDecision decision,
    required WorkflowRun current,
    required CredentialRepository credentialRepo,
    required String? editedContent,
  }) async {
    switch (decision) {
      case ApprovalDecision.reject:
        return SubmitApprovalRequest(decision: decision);
      case ApprovalDecision.accept:
        final approvalIndex = current.waitingApprovalIndex();
        if (approvalIndex == null) {
          return SubmitApprovalRequest(decision: decision);
        }
        if (!current.hasRemainingWorkAfterApproval(approvalIndex)) {
          return SubmitApprovalRequest(decision: decision);
        }
        if (current.hasRemainingIntegrationAfterApproval(approvalIndex)) {
          return _approvalRequestWithCredentials(
            decision: decision,
            current: current,
            credentialRepo: credentialRepo,
            editedContent: null,
          );
        }
        return _approvalRequestWithCredentials(
          decision: decision,
          current: current,
          credentialRepo: credentialRepo,
          editedContent: null,
        );
      case ApprovalDecision.edit:
        return _approvalRequestWithCredentials(
          decision: decision,
          current: current,
          credentialRepo: credentialRepo,
          editedContent: editedContent,
        );
    }
  }

  Future<SubmitApprovalRequest> _approvalRequestWithCredentials({
    required ApprovalDecision decision,
    required WorkflowRun current,
    required CredentialRepository credentialRepo,
    required String? editedContent,
  }) async {
    final details = await ref.read(presetDetailsProvider.future);
    if (details == null) {
      throw StateError('Preset details are required');
    }
    final overrideProviders = await _overrideProvidersForRun(current);
    final workflowInputs = await _workflowInputsForRun(current);
    final keys = details.approvalCredentialKeys(
      run: current,
      decision: decision,
      overrideProvidersByAgent: overrideProviders,
      workflowInputs: workflowInputs,
    );
    if (keys.isEmpty) {
      return SubmitApprovalRequest(
        decision: decision,
        editedContent: editedContent,
      );
    }
    final credentials = await credentialRepo.readForEnvelopeKeysWithConnectors(keys);
    final missing = credentialRepo.missingEnvelopeKeys(keys, credentials);
    if (missing.isNotEmpty) {
      throw StateError('Missing credentials: ${missing.join(', ')}');
    }
    final envelope = await ref
        .read(credentialEnvelopeServiceProvider)
        .encrypt(credentials);
    return SubmitApprovalRequest(
      decision: decision,
      editedContent: editedContent,
      credentials: envelope,
    );
  }

  Future<Map<String, String>> _workflowInputsForRun(WorkflowRun run) async {
    var localWorkflowId = run.localWorkflowId?.trim();
    if (localWorkflowId == null || localWorkflowId.isEmpty) {
      final persisted = await ref
          .read(workflowRepositoryProvider)
          .getLocalRun(run.runId);
      localWorkflowId = persisted?.localWorkflowId?.trim();
    }
    if (localWorkflowId != null && localWorkflowId.isNotEmpty) {
      final configuration = await ref
          .read(scheduleRepositoryProvider)
          .getConfiguration(localWorkflowId);
      if (configuration != null && configuration.inputs.isNotEmpty) {
        return configuration.inputs;
      }
    }
    return Map<String, String>.from(ref.read(runConfigTempProvider).inputs);
  }

  Future<Map<String, String>> _overrideProvidersForRun(WorkflowRun run) async {
    final repo = ref.read(workflowRepositoryProvider);
    var localWorkflowId = run.localWorkflowId?.trim();
    if (localWorkflowId == null || localWorkflowId.isEmpty) {
      final persisted = await repo.getLocalRun(run.runId);
      localWorkflowId = persisted?.localWorkflowId?.trim();
    }
    if (localWorkflowId != null && localWorkflowId.isNotEmpty) {
      final instance = await repo.getInstance(localWorkflowId);
      final overrides = _parseModelOverrides(instance?.modelOverridesJson);
      if (overrides.isNotEmpty) {
        return {
          for (final override in overrides)
            if (override.provider != null && override.provider!.isNotEmpty)
              override.agentKey: override.provider!,
        };
      }
    }
    return {
      for (final node in run.nodes)
        if (node.type == 'Agent' &&
            node.effectiveProvider != null &&
            node.effectiveProvider!.isNotEmpty)
          node.nodeKey: node.effectiveProvider!,
    };
  }

  Future<String> _resolveLocalWorkflowId(WorkflowRun run) async {
    var localWorkflowId = run.localWorkflowId?.trim();
    if (localWorkflowId != null && localWorkflowId.isNotEmpty) {
      return localWorkflowId;
    }
    final persisted = await ref
        .read(workflowRepositoryProvider)
        .getLocalRun(run.runId);
    return persisted?.localWorkflowId?.trim() ?? '';
  }

  List<AgentOverrideRequest> _parseModelOverrides(String? json) {
    if (json == null || json.trim().isEmpty) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map(
          (item) => AgentOverrideRequest.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> _reconcileAfterStartTimeout(
    String localWorkflowId,
    DateTime? expiryUtc,
  ) async {
    if (!ref.mounted) return;
    ref.read(workflowTransportProvider.notifier).setReconciling();
    try {
      await ref.read(workflowHubClientProvider).reconnect();
    } catch (_) {}
    final run = await ref
        .read(workflowRepositoryProvider)
        .reconcileLatestForWorkflow(localWorkflowId, expiryUtc: expiryUtc);
    if (!ref.mounted) return;
    if (run != null) {
      _applyReconciledRun(run);
    } else {
      ref.read(workflowTransportProvider.notifier).setProcessing();
    }
  }

  Future<void> _reconcileRun(
    String runId,
    String localWorkflowId,
    DateTime? expiryUtc,
  ) async {
    if (!ref.mounted) return;
    ref.read(workflowTransportProvider.notifier).setReconciling();
    try {
      await ref.read(workflowHubClientProvider).reconnect();
    } catch (_) {}
    try {
      final run = await ref
          .read(workflowRepositoryProvider)
          .reconcileByRunId(
            runId,
            localWorkflowId: localWorkflowId,
            expiryUtc: expiryUtc,
          );
      if (!ref.mounted) return;
      if (run != null) {
        _applyReconciledRun(run);
        return;
      }
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        await ref.read(workflowRepositoryProvider).markExpired(runId);
        final local = await ref
            .read(workflowRepositoryProvider)
            .getLocalRun(runId);
        if (local != null && ref.mounted) {
          state = AsyncData(local.copyWith(status: WorkflowRunStatus.expired));
        }
        ref.read(workflowTransportProvider.notifier).clear();
        return;
      }
    }
    if (ref.mounted) {
      ref.read(workflowTransportProvider.notifier).setProcessing();
    }
  }

  void _applyReconciledRun(WorkflowRun run) {
    ref.read(selectedRunIdProvider.notifier).update(run.runId);
    _lastEventAt = DateTime.now().toUtc();
    state = AsyncData(run);
    if (run.status == WorkflowRunStatus.waitingForApproval) {
      ref
          .read(workflowTransportProvider.notifier)
          .clearLockedApprovalIfWaiting(_pendingApprovalNodeId(run));
    }
    if (isReconcileTerminal(run.status)) {
      ref.read(workflowTransportProvider.notifier).clear();
    } else {
      ref.read(workflowTransportProvider.notifier).setProcessing();
    }
    unawaited(
      ref
          .read(workflowHubClientProvider)
          .subscribeToRun(run.runId)
          .catchError((_) {}),
    );
  }

  String? _pendingApprovalNodeId(WorkflowRun run) {
    final index = run.waitingApprovalIndex();
    if (index == null) return null;
    return run.nodes[index].nodeId;
  }

  WorkflowRun _optimisticApproval(WorkflowRun run, ApprovalDecision decision) {
    final approvalIndex = run.nodes.indexWhere(
      (node) => node.status == WorkflowNodeStatus.waitingForApproval,
    );
    if (approvalIndex < 0) return run;
    final writerIndex = _writerIndexBeforeApproval(run, approvalIndex);
    final nodes = [
      for (var i = 0; i < run.nodes.length; i++)
        if (i == approvalIndex ||
            (decision == ApprovalDecision.edit && i == writerIndex))
          run.nodes[i].copyWith(
            status: WorkflowNodeStatus.running,
            isRunning: true,
          )
        else if (i > approvalIndex)
          run.nodes[i].copyWith(
            status: WorkflowNodeStatus.idle,
            isRunning: false,
            output: null,
            error: null,
          )
        else if (decision == ApprovalDecision.edit &&
            writerIndex != null &&
            i > writerIndex &&
            i < approvalIndex)
          run.nodes[i].copyWith(
            status: WorkflowNodeStatus.idle,
            isRunning: false,
            output: null,
            error: null,
          )
        else
          run.nodes[i],
    ];
    return run.copyWith(nodes: nodes, status: WorkflowRunStatus.running);
  }

  int? _writerIndexBeforeApproval(WorkflowRun run, int approvalIndex) {
    if (approvalIndex <= 0) return null;
    for (var i = approvalIndex - 1; i >= 0; i--) {
      if (run.nodes[i].type == 'Agent') return i;
    }
    return null;
  }

  Future<void> _onEvent(WorkflowNodeChanged event) async {
    final current = state.value;
    if (current == null || current.runId != event.runId) return;
    if (_lastEventAt != null && !event.occurredAtUtc.isAfter(_lastEventAt!)) {
      return;
    }
    _lastEventAt = event.occurredAtUtc;
    final merged = const WorkflowRunMapper().mergeEvent(current, event);
    await ref.read(workflowRepositoryProvider).persistRun(merged);
    if (ref.mounted) state = AsyncData(merged);
    if (shouldRefetchRunSnapshotForNode(merged, event)) {
      await _refreshRunSnapshot(merged);
    }
  }

  Future<void> _refreshRunSnapshot(WorkflowRun run) async {
    if (!ref.mounted || state.value?.runId != run.runId) return;
    try {
      final repo = ref.read(workflowRepositoryProvider);
      final dto = await repo.fetchRemote(run.runId);
      if (!ref.mounted || state.value?.runId != run.runId) return;
      var localWorkflowId = run.localWorkflowId?.trim();
      if (localWorkflowId == null || localWorkflowId.isEmpty) {
        localWorkflowId = (await repo.getLocalRun(run.runId))
            ?.localWorkflowId
            ?.trim();
      }
      final refreshed = await repo.persistDto(
        dto,
        localWorkflowId: localWorkflowId ?? '',
        expiryUtc: run.expiryUtc,
      );
      if (!ref.mounted || state.value?.runId != refreshed.runId) return;
      _lastEventAt = DateTime.now().toUtc();
      state = AsyncData(refreshed);
    } catch (_) {}
  }
}
