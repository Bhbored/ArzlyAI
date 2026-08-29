import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/agent_override_request.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/start_workflow_request.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/submit_approval_request.dart';
import 'package:arzlyai_mobile/core/realtime/workflow_hub_client.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/domain/entities/credentials/credential_requirement.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/repositories/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
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
    try {
      final online = ref.read(internetConnectionProvider);
      final offlineMode = await ref.read(offlineModeProvider.future);
      if (!online || offlineMode) {
        state = AsyncError(StateError('Generation requires a network connection'), StackTrace.current);
        return;
      }
      final details = await ref.read(presetDetailsProvider.future);
      if (details == null) return;
      final topicError = AppValidators.requiredNonEmpty(config.topic);
      if (topicError != null) {
        state = AsyncError(ArgumentError(topicError), StackTrace.current);
        return;
      }
      final writer = details.configurableWorkflowAgent();
      final overrides = <AgentOverrideRequest>[];
      if (writer != null) {
        String? model;
        double? temperature;
        if (writer.modelConfiguration.isModelEditable) {
          model = config.model ?? writer.modelConfiguration.selectedModel;
        }
        if (writer.modelConfiguration.isTemperatureEditable) {
          temperature = AppValidators.clampTemperature(
            config.temperature ?? writer.modelConfiguration.temperature,
            writer.modelConfiguration.minimumTemperature,
            writer.modelConfiguration.maximumTemperature,
          );
        }
        if (model != null || temperature != null) {
          overrides.add(
            AgentOverrideRequest(
              agentKey: writer.key,
              model: model,
              temperature: temperature,
            ),
          );
        }
      }
      state = const AsyncLoading();
      final credentialRepo = ref.read(credentialRepositoryProvider);
      final startKeys = details.envelopeKeysForPhase(CredentialPhase.workflowStart);
      final startCredentials = await credentialRepo.readForPreset(
        details,
        CredentialPhase.workflowStart,
      );
      final missingStart = credentialRepo.missingEnvelopeKeys(
        startKeys,
        startCredentials,
      );
      if (missingStart.isNotEmpty) {
        throw StateError('Missing credentials: ${missingStart.join(', ')}');
      }
      final envelope = await ref.read(credentialEnvelopeServiceProvider).encrypt(
        startCredentials,
      );
      final instance = await ref.read(workflowRepositoryProvider).createInstance(
        presetKey: details.key,
        presetVersion: details.version,
        name: details.name,
        topic: config.topic.trim(),
        modelOverridesJson: jsonEncode(
          overrides.map((e) => e.toJson()).toList(),
        ),
      );
      final dto = await ref.read(workflowServiceProvider).start(
        StartWorkflowRequest(
          presetKey: details.key,
          inputs: {'topic': config.topic.trim()},
          agentOverrides: overrides,
          credentials: envelope,
        ),
      );
      final run = await ref.read(workflowRepositoryProvider).persistDto(
        dto,
        localWorkflowId: instance.id,
        expiryUtc: DateTime.now().toUtc().add(const Duration(minutes: 30)),
      );
      ref.read(selectedRunIdProvider.notifier).update(run.runId);
      _lastEventAt = DateTime.now().toUtc();
      await ref.read(workflowHubClientProvider).subscribeToRun(run.runId);
      state = AsyncData(run);
    } catch (e, s) {
      state = AsyncError(e, s);
    } finally {
      _busy = false;
    }
  }

  Future<void> recover() async {
    final runId = ref.read(selectedRunIdProvider);
    if (runId == null) return;
    try {
      await ref.read(workflowHubClientProvider).reconnect();
      final dto = await ref.read(workflowRepositoryProvider).fetchRemote(runId);
      final local = await ref.read(workflowRepositoryProvider).getLocalRun(runId);
      final run = await ref.read(workflowRepositoryProvider).persistDto(
        dto,
        localWorkflowId: local?.localWorkflowId ?? '',
        expiryUtc: local?.expiryUtc,
      );
      _lastEventAt = DateTime.now().toUtc();
      state = AsyncData(run);
    } on ApiException catch (e, s) {
      if (e.statusCode == 404) {
        await ref.read(workflowRepositoryProvider).markExpired(runId);
        final local = await ref.read(workflowRepositoryProvider).getLocalRun(runId);
        if (local != null) {
          state = AsyncData(
            local.copyWith(status: WorkflowRunStatus.expired),
          );
        }
        return;
      }
      state = AsyncError(e, s);
    }
  }

  Future<void> submitApproval(
    ApprovalDecision decision, {
    String? editedContent,
  }) async {
    if (_busy) return;
    _busy = true;
    try {
      final online = ref.read(internetConnectionProvider);
      final offlineMode = await ref.read(offlineModeProvider.future);
      if (!online || offlineMode) {
        state = AsyncError(StateError('Publishing requires a network connection'), StackTrace.current);
        return;
      }
      final current = state.value;
      if (current == null) return;
      if (decision == ApprovalDecision.edit) {
        if (AppValidators.requiredNonEmpty(editedContent ?? '') != null) {
          state = AsyncError(ArgumentError('Edited content is required'), StackTrace.current);
          return;
        }
      }
      final credentialRepo = ref.read(credentialRepositoryProvider);
      SubmitApprovalRequest request;
      if (decision == ApprovalDecision.reject) {
        request = SubmitApprovalRequest(decision: decision);
      } else {
        final details = await ref.read(presetDetailsProvider.future);
        if (details == null) {
          throw StateError('Preset details are required');
        }
        final approvalKeys = details.envelopeKeysForPhase(CredentialPhase.approval);
        final approvalCredentials = await credentialRepo.readForPreset(
          details,
          CredentialPhase.approval,
        );
        final missingApproval = credentialRepo.missingEnvelopeKeys(
          approvalKeys,
          approvalCredentials,
        );
        if (missingApproval.isNotEmpty) {
          throw StateError('Missing credentials: ${missingApproval.join(', ')}');
        }
        final envelope = await ref.read(credentialEnvelopeServiceProvider).encrypt(
          approvalCredentials,
        );
        request = SubmitApprovalRequest(
          decision: decision,
          editedContent: decision == ApprovalDecision.edit ? editedContent : null,
          credentials: envelope,
        );
      }
      final dto = await ref.read(workflowServiceProvider).submitApproval(
        current.runId,
        request,
      );
      final run = await ref.read(workflowRepositoryProvider).persistDto(
        dto,
        localWorkflowId: current.localWorkflowId ?? '',
        expiryUtc: current.expiryUtc,
      );
      state = AsyncData(run);
    } catch (e, s) {
      state = AsyncError(e, s);
    } finally {
      _busy = false;
    }
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
  }
}
