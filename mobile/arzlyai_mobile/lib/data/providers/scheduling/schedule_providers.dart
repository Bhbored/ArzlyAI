import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:arzlyai_mobile/core/background/workflow_background_dispatcher.dart';
import 'package:arzlyai_mobile/core/background/workflow_scheduling_composition.dart';
import 'package:arzlyai_mobile/core/notifications/local_notification_service.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/preset/preset_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/services/scheduling/scheduled_workflow_executor.dart';
import 'package:arzlyai_mobile/data/services/scheduling/workflow_scheduler.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';

part 'schedule_providers.g.dart';

Duration? scheduleRetry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: scheduleRetry)
Future<LocalNotificationService> localNotificationService(Ref ref) async {
  final service = await LocalNotificationService.create();
  ref.onDispose(() {});
  return service;
}

@Riverpod(keepAlive: true, retry: scheduleRetry)
Future<WorkflowScheduler> workflowScheduler(Ref ref) async {
  final notifications = await ref.watch(localNotificationServiceProvider.future);
  return WorkflowScheduler(
    scheduleRepository: ref.watch(scheduleRepositoryProvider),
    notifications: notifications,
  );
}

@Riverpod(keepAlive: true, retry: scheduleRetry)
Future<ScheduledWorkflowExecutor> scheduledWorkflowExecutor(Ref ref) async {
  final notifications = await ref.watch(localNotificationServiceProvider.future);
  final scheduler = await ref.watch(workflowSchedulerProvider.future);
  return ScheduledWorkflowExecutor(
    workflowRepository: ref.watch(workflowRepositoryProvider),
    presetRepository: ref.watch(presetRepositoryProvider),
    credentialRepository: ref.watch(credentialRepositoryProvider),
    envelopeService: ref.watch(credentialEnvelopeServiceProvider),
    workflowService: ref.watch(workflowServiceProvider),
    scheduleRepository: ref.watch(scheduleRepositoryProvider),
    notifications: notifications,
    scheduler: scheduler,
  );
}

@Riverpod(retry: scheduleRetry)
Future<bool> workflowScheduleEnabled(Ref ref, String localWorkflowId) async {
  final schedule = await ref
      .read(scheduleRepositoryProvider)
      .getByWorkflowId(localWorkflowId);
  return schedule?.enabled ?? false;
}

@Riverpod(retry: scheduleRetry)
Future<String?> scheduledWorkflowIdForPreset(Ref ref, String presetKey) async {
  final schedules = await ref.read(scheduleRepositoryProvider).listAll();
  for (final schedule in schedules) {
    final instance = await ref
        .read(workflowRepositoryProvider)
        .getInstance(schedule.localWorkflowId);
    if (instance?.presetKey == presetKey) {
      return schedule.localWorkflowId;
    }
  }
  return null;
}

@Riverpod(keepAlive: true, retry: scheduleRetry)
Future<void> initializeWorkflowScheduling(Ref ref) async {
  await WorkflowSchedulingComposition.initializeTimeZone();
  if (!ref.mounted) return;
  await Workmanager().initialize(workflowBackgroundDispatcher);
  if (!ref.mounted) return;
  final scheduler = await ref.read(workflowSchedulerProvider.future);
  if (!ref.mounted) return;
  await scheduler.reconcileEnabledSchedules();
}

@Riverpod(keepAlive: true, retry: scheduleRetry)
class ScheduleController extends _$ScheduleController {
  @override
  FutureOr<void> build(String localWorkflowId) {}

  Future<void> enable({
    required String localTime,
    required String timeZoneId,
  }) async {
    state = const AsyncLoading();
    try {
      final schedule = await ref.read(scheduleRepositoryProvider).upsert(
        localWorkflowId: localWorkflowId,
        localTime: localTime,
        timeZoneId: timeZoneId,
        enabled: true,
      );
      final scheduler = await ref.read(workflowSchedulerProvider.future);
      await scheduler.registerSchedule(schedule);
      ref.invalidate(workflowScheduleEnabledProvider(localWorkflowId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> disable() async {
    state = const AsyncLoading();
    try {
      await ref.read(scheduleRepositoryProvider).setEnabled(localWorkflowId, false);
      final scheduler = await ref.read(workflowSchedulerProvider.future);
      await scheduler.cancelSchedule(localWorkflowId);
      ref.invalidate(workflowScheduleEnabledProvider(localWorkflowId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> runNow() async {
    state = const AsyncLoading();
    try {
      final executor = await ref.read(scheduledWorkflowExecutorProvider.future);
      await executor.execute(localWorkflowId);
      ref.invalidate(workflowScheduleEnabledProvider(localWorkflowId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
