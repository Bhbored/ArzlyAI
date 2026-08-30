import 'package:workmanager/workmanager.dart';
import 'package:arzlyai_mobile/core/notifications/local_notification_service.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_task_keys.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/workflow_schedule.dart';

class WorkflowScheduler {
  WorkflowScheduler({
    required this.scheduleRepository,
    required this.notifications,
  });

  final ScheduleRepository scheduleRepository;
  final LocalNotificationService notifications;

  Future<void> registerSchedule(WorkflowSchedule schedule) async {
    if (!schedule.enabled) {
      await cancelSchedule(schedule.localWorkflowId);
      return;
    }

    final taskId =
        schedule.platformTaskId ??
        ScheduleTaskKeys.platformTaskId(schedule.localWorkflowId);
    final delay = schedule.nextRunAtUtc.difference(DateTime.now().toUtc());
    final initialDelay = delay.isNegative ? Duration.zero : delay;

    await Workmanager().registerOneOffTask(
      taskId,
      ScheduleTaskKeys.backgroundTaskName,
      initialDelay: initialDelay,
      constraints: Constraints(networkType: NetworkType.connected),
      inputData: {'localWorkflowId': schedule.localWorkflowId},
    );
    await notifications.scheduleReminder(schedule);
  }

  Future<void> cancelSchedule(String localWorkflowId) async {
    await notifications.cancelReminder(localWorkflowId);
    try {
      await Workmanager().cancelByUniqueName(
        ScheduleTaskKeys.platformTaskId(localWorkflowId),
      );
    } on Object {
      // Workmanager is unavailable outside supported mobile hosts.
    }
  }

  Future<void> reconcileEnabledSchedules() async {
    final schedules = await scheduleRepository.listEnabled();
    for (final schedule in schedules) {
      await registerSchedule(schedule);
    }
  }
}
