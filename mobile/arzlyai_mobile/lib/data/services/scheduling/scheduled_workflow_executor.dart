import 'dart:convert';

import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/agent_override_request.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/start_workflow_request.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/core/notifications/local_notification_service.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_outcomes.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/preset/preset_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/data/services/scheduling/workflow_scheduler.dart';
import 'package:arzlyai_mobile/domain/entities/credentials/credential_requirement.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';

class ScheduledWorkflowExecutor {
  ScheduledWorkflowExecutor({
    required this.workflowRepository,
    required this.presetRepository,
    required this.credentialRepository,
    required this.envelopeService,
    required this.workflowService,
    required this.scheduleRepository,
    required this.notifications,
    required this.scheduler,
  });

  final WorkflowRepository workflowRepository;
  final PresetRepository presetRepository;
  final CredentialRepository credentialRepository;
  final CredentialEnvelopeService envelopeService;
  final WorkflowService workflowService;
  final ScheduleRepository scheduleRepository;
  final LocalNotificationService notifications;
  final WorkflowScheduler scheduler;

  Future<void> execute(String localWorkflowId) async {
    if (!await scheduleRepository.tryClaimOccurrence(localWorkflowId)) {
      return;
    }

    if (await workflowRepository.hasPendingApproval(localWorkflowId)) {
      final pending = await workflowRepository.latestRunForWorkflow(localWorkflowId);
      await scheduleRepository.recordSuccess(
        localWorkflowId: localWorkflowId,
        outcome: ScheduleOutcomes.skipped,
      );
      if (pending != null) {
        await notifications.showSkippedReview(
          localWorkflowId: localWorkflowId,
          runId: pending.runId,
        );
      }
      final schedule = await scheduleRepository.getByWorkflowId(localWorkflowId);
      if (schedule != null) {
        await scheduler.registerSchedule(schedule);
      }
      return;
    }

    try {
      final instance = await workflowRepository.getInstance(localWorkflowId);
      if (instance == null) {
        throw StateError('Workflow configuration is missing.');
      }

      final details = await presetRepository.cachedDetails(
        instance.presetKey,
        instance.presetVersion,
      );
      if (details == null) {
        throw StateError('Preset details are not available offline.');
      }

      final keys = details.envelopeKeysForPhase(CredentialPhase.workflowStart);
      final credentials = await credentialRepository.readForEnvelopeKeys(keys);
      final missing = credentialRepository.missingEnvelopeKeys(keys, credentials);
      if (missing.isNotEmpty) {
        throw StateError('OpenAI API key is required.');
      }

      final envelope = await envelopeService.encrypt(credentials);
      final overrides = _parseOverrides(instance.modelOverridesJson);

      final dto = await workflowService.start(
        StartWorkflowRequest(
          presetKey: instance.presetKey,
          inputs: {'topic': instance.topic.trim()},
          agentOverrides: overrides,
          credentials: envelope,
        ),
      );

      final run = await workflowRepository.persistDto(
        dto,
        localWorkflowId: localWorkflowId,
        expiryUtc: DateTime.now().toUtc().add(const Duration(minutes: 30)),
      );

      await notifications.cancelReminder(localWorkflowId);

      if (run.status == WorkflowRunStatus.waitingForApproval) {
        await scheduleRepository.recordSuccess(
          localWorkflowId: localWorkflowId,
          outcome: ScheduleOutcomes.waitingForUser,
        );
        await notifications.showDraftReady(
          localWorkflowId: localWorkflowId,
          runId: run.runId,
        );
      } else if (run.status == WorkflowRunStatus.failed) {
        throw StateError('Workflow generation failed.');
      } else {
        await scheduleRepository.recordSuccess(
          localWorkflowId: localWorkflowId,
          outcome: ScheduleOutcomes.started,
        );
      }

      final schedule = await scheduleRepository.getByWorkflowId(localWorkflowId);
      if (schedule != null && schedule.enabled) {
        await scheduler.registerSchedule(schedule);
      }
    } catch (error) {
      final message = _sanitize(error);
      await scheduleRepository.recordFailure(
        localWorkflowId: localWorkflowId,
        message: message,
      );
      await notifications.showTapToRun(
        localWorkflowId: localWorkflowId,
        message: message,
      );
    }
  }

  List<AgentOverrideRequest> _parseOverrides(String? json) {
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

  String _sanitize(Object error) {
    if (error is ApiException) return error.userMessage;
    if (error is StateError) return error.message;
    return 'Workflow could not run in the background.';
  }
}
