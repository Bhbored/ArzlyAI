import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:arzlyai_mobile/core/notifications/notification_payload.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/workflow_schedule.dart';

abstract final class NotificationChannels {
  static const reminders = 'workflow_reminders';
  static const results = 'workflow_results';
}

class LocalNotificationService {
  LocalNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  static NotificationPayload? _pendingTap;
  static void Function(NotificationResponse)? _tapHandler;

  static Future<LocalNotificationService> create() async {
    final plugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final payload = NotificationPayload.decode(response.payload);
        if (payload != null) {
          _pendingTap = payload;
          _tapHandler?.call(response);
        }
      },
    );
    final service = LocalNotificationService(plugin);
    await service._createChannels();
    return service;
  }

  NotificationPayload? consumePendingTap() {
    final pending = _pendingTap;
    _pendingTap = null;
    return pending;
  }

  void setTapHandler(void Function(NotificationResponse)? handler) {
    _tapHandler = handler;
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(alert: true, badge: true);
      return granted ?? false;
    }
    return true;
  }

  Future<void> scheduleReminder(WorkflowSchedule schedule) async {
    final id = _reminderId(schedule.localWorkflowId);
    await _plugin.zonedSchedule(
      id: id,
      title: 'ArzlyAI workflow due',
      body: 'Your ArzlyAI workflow is due—tap to run it.',
      scheduledDate: tz.TZDateTime.from(schedule.nextRunAtUtc, tz.UTC),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: NotificationPayload(
        action: NotificationActions.run,
        localWorkflowId: schedule.localWorkflowId,
      ).encode(),
      notificationDetails: _reminderDetails(),
    );
  }

  Future<void> cancelReminder(String localWorkflowId) async {
    await _plugin.cancel(id: _reminderId(localWorkflowId));
  }

  Future<void> showDraftReady({
    required String localWorkflowId,
    required String runId,
  }) async {
    await _plugin.show(
      id: _resultId(localWorkflowId),
      title: 'LinkedIn draft ready',
      body: 'Your LinkedIn draft is ready to review.',
      notificationDetails: _resultDetails(),
      payload: NotificationPayload(
        action: NotificationActions.review,
        localWorkflowId: localWorkflowId,
        runId: runId,
      ).encode(),
    );
  }

  Future<void> showTapToRun({
    required String localWorkflowId,
    String? message,
  }) async {
    await _plugin.show(
      id: _resultId(localWorkflowId),
      title: 'ArzlyAI workflow due',
      body: message ?? 'Your ArzlyAI workflow is due—tap to run it.',
      notificationDetails: _reminderDetails(),
      payload: NotificationPayload(
        action: NotificationActions.run,
        localWorkflowId: localWorkflowId,
      ).encode(),
    );
  }

  Future<void> showSkippedReview({
    required String localWorkflowId,
    required String runId,
  }) async {
    await _plugin.show(
      id: _resultId(localWorkflowId),
      title: 'Review your draft',
      body: 'A LinkedIn draft is already waiting for your review.',
      notificationDetails: _resultDetails(),
      payload: NotificationPayload(
        action: NotificationActions.review,
        localWorkflowId: localWorkflowId,
        runId: runId,
      ).encode(),
    );
  }

  Future<void> _createChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.reminders,
        'Workflow reminders',
        description: 'Due and tap-to-run workflow reminders',
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.results,
        'Workflow results',
        description: 'Draft-ready and outcome notifications',
      ),
    );
  }

  NotificationDetails _reminderDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.reminders,
        'Workflow reminders',
        channelDescription: 'Due and tap-to-run workflow reminders',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  NotificationDetails _resultDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.results,
        'Workflow results',
        channelDescription: 'Draft-ready and outcome notifications',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  int _reminderId(String localWorkflowId) => localWorkflowId.hashCode;

  int _resultId(String localWorkflowId) => localWorkflowId.hashCode + 1;
}
