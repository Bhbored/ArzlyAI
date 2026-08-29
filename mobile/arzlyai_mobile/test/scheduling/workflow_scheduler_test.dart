import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/notifications/local_notification_service.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_task_keys.dart';
import 'package:arzlyai_mobile/data/repositories/schedule_repository.dart';
import 'package:arzlyai_mobile/data/services/scheduling/workflow_scheduler.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

void main() {
  test('disable cancels reminder notification', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final scheduleRepository = ScheduleRepository(
      db,
      const ScheduleOccurrenceCalculator(),
    );
    final notifications = RecordingNotifications();
    final scheduler = WorkflowScheduler(
      scheduleRepository: scheduleRepository,
      notifications: notifications,
    );

    try {
      await scheduler.cancelSchedule('wf-1');
    } on Object {
      // Workmanager may be unavailable in the Dart VM test host.
    }

    expect(notifications.reminderCancelled, isTrue);
    await db.close();
  });

  test('platform task id is deterministic per workflow', () {
    expect(
      ScheduleTaskKeys.platformTaskId('wf-abc'),
      ScheduleTaskKeys.platformTaskId('wf-abc'),
    );
    expect(
      ScheduleTaskKeys.platformTaskId('wf-1'),
      isNot(ScheduleTaskKeys.platformTaskId('wf-2')),
    );
  });
}

class RecordingNotifications extends LocalNotificationService {
  RecordingNotifications()
    : super(FlutterLocalNotificationsPlugin());

  bool reminderCancelled = false;

  @override
  Future<void> cancelReminder(String localWorkflowId) async {
    reminderCancelled = true;
  }
}
