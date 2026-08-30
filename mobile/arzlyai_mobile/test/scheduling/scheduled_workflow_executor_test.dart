import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/notifications/notification_payload.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_outcomes.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/preset/preset_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/data/services/scheduling/scheduled_workflow_executor.dart';
import 'package:arzlyai_mobile/data/services/scheduling/workflow_scheduler.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/notifications/local_notification_service.dart';
import 'package:arzlyai_mobile/core/network/services/preset/preset_service.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/workflow_schedule.dart';
import '../helpers/fakes.dart';

void main() {
  late AppDatabase db;
  late ScheduleRepository scheduleRepository;
  late WorkflowRepository workflowRepository;
  late PresetRepository presetRepository;
  late MemoryCredentialStore credentialStore;
  late CredentialRepository credentialRepository;
  late FakeEnvelopeService envelopeService;
  late FakeWorkflowService workflowService;
  late RecordingNotifications notifications;
  late RecordingScheduler scheduler;
  late ScheduledWorkflowExecutor executor;
  late String localWorkflowId;

  setUp(() async {
    tz_data.initializeTimeZones();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    scheduleRepository = ScheduleRepository(
      db,
      const ScheduleOccurrenceCalculator(),
    );
    workflowService = FakeWorkflowService();
    workflowRepository = WorkflowRepository(
      db,
      workflowService,
      const WorkflowRunMapper(),
      const ArzlyReportMapper(),
    );
    presetRepository = PresetRepository(
      db,
      FakePresetService(),
      const PresetMapper(),
    );
    credentialStore = MemoryCredentialStore();
    credentialRepository = CredentialRepository(
      credentialStore,
      ConnectorCredentialRepository(db),
    );
    envelopeService = FakeEnvelopeService();
    notifications = RecordingNotifications();
    scheduler = RecordingScheduler(
      scheduleRepository: scheduleRepository,
      notifications: notifications,
    );
    executor = ScheduledWorkflowExecutor(
      workflowRepository: workflowRepository,
      presetRepository: presetRepository,
      credentialRepository: credentialRepository,
      envelopeService: envelopeService,
      workflowService: workflowService,
      scheduleRepository: scheduleRepository,
      notifications: notifications,
      scheduler: scheduler,
    );

    await seedPresetCache(db);
    final instance = await workflowRepository.createInstance(
      presetKey: 'daily-linkedin-ai-post',
      presetVersion: 1,
      name: 'Daily',
      topic: 'AI agents',
    );
    localWorkflowId = instance.id;

    credentialStore.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    await seedLinkedInConnector(db);

    final due = DateTime.now().toUtc().subtract(const Duration(minutes: 1));
    await scheduleRepository.upsert(
      localWorkflowId: localWorkflowId,
      localTime: '08:00',
      timeZoneId: 'UTC',
      enabled: true,
      nextRunAtUtc: due,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('background generation uses OpenAI credentials but not LinkedIn', () async {
    await executor.execute(localWorkflowId);

    expect(workflowService.startCount, 1);
    expect(
      envelopeService.lastCredentials?.keys,
      contains(providerCredentialEnvelopeKey('openai')),
    );
    expect(
      envelopeService.lastCredentials?.keys.any(
        (key) => key.contains('linkedin'),
      ),
      isFalse,
    );
    expect(workflowService.lastStart?.credentials.requestId, 'r');
  });

  test('waiting for approval persists run and shows draft-ready notification', () async {
    await executor.execute(localWorkflowId);

    expect(notifications.lastDraftReadyRunId, workflowService.startResult.runId);
    expect(notifications.lastDraftReadyAction, NotificationActions.review);
    expect(notifications.reminderCancelled, isTrue);

    final schedule = await scheduleRepository.getByWorkflowId(localWorkflowId);
    expect(schedule?.lastOutcome, ScheduleOutcomes.waitingForUser);

    final run = await workflowRepository.getLocalRun(
      workflowService.startResult.runId,
    );
    expect(run?.status, WorkflowRunStatus.waitingForApproval);
  });

  test('existing pending approval prevents overlapping generation', () async {
    await executor.execute(localWorkflowId);
    workflowService.startCount = 0;

    final due = DateTime.now().toUtc().subtract(const Duration(minutes: 1));
    await (db.update(db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .write(
      SchedulesCompanion(
        nextRunAtUtc: Value(due),
        lastSucceededAtUtc: const Value(null),
        lastAttemptAtUtc: const Value(null),
        lastOutcome: const Value(null),
      ),
    );

    await executor.execute(localWorkflowId);

    expect(workflowService.startCount, 0);
    expect(notifications.lastSkippedRunId, workflowService.startResult.runId);
    final schedule = await scheduleRepository.getByWorkflowId(localWorkflowId);
    expect(schedule?.lastOutcome, ScheduleOutcomes.skipped);
    expect(scheduler.registerCount, greaterThan(0));
  });

  test('offline failure produces tap-to-run notification', () async {
    workflowService.startError = const ApiException(
      userMessage: 'You appear to be offline.',
      error: 'offline',
      originalError: 'x',
    );

    await executor.execute(localWorkflowId);

    expect(notifications.tapToRunShown, isTrue);
    expect(notifications.tapToRunMessage, 'You appear to be offline.');
    final schedule = await scheduleRepository.getByWorkflowId(localWorkflowId);
    expect(schedule?.lastOutcome, ScheduleOutcomes.failed);
  });

  test('fresh envelope is built per attempt and never persisted in schedule', () async {
    await executor.execute(localWorkflowId);
    expect(envelopeService.encryptCount, 1);
    expect(workflowService.lastStart?.credentials.requestId, 'r');

    final instance = await workflowRepository.createInstance(
      presetKey: 'daily-linkedin-ai-post',
      presetVersion: 1,
      name: 'Daily 2',
      topic: 'Agents',
    );
    final due = DateTime.now().toUtc().subtract(const Duration(minutes: 1));
    await scheduleRepository.upsert(
      localWorkflowId: instance.id,
      localTime: '08:00',
      timeZoneId: 'UTC',
      enabled: true,
      nextRunAtUtc: due,
    );

    await executor.execute(instance.id);

    expect(envelopeService.encryptCount, 2);
    expect(workflowService.lastStart?.credentials.requestId, 'r');

    final dump = await db.customSelect('SELECT * FROM schedules').get();
    final encoded = dump.map((row) => row.data.toString()).join();
    expect(encoded.contains('wrappedKey'), isFalse);
    expect(encoded.contains('ciphertext'), isFalse);
  });
}

Future<void> seedPresetCache(AppDatabase db) async {
  final json = fixtureJson('preset_details.json');
  await db
      .into(db.presetCache)
      .insertOnConflictUpdate(
        PresetCacheCompanion.insert(
          key: 'daily-linkedin-ai-post',
          version: 1,
          responseJson: jsonEncode(
            PresetDetailsResponse.fromJson(json).toJson(),
          ),
          fetchedAtUtc: DateTime.now().toUtc(),
        ),
      );
}

class FakePresetService extends PresetService {
  FakePresetService() : super(ApiExecutor(Dio()), Dio());
}

class RecordingNotifications extends LocalNotificationService {
  RecordingNotifications()
    : super(FlutterLocalNotificationsPlugin());

  bool reminderCancelled = false;
  String? lastDraftReadyRunId;
  String? lastDraftReadyAction;
  String? lastSkippedRunId;
  bool tapToRunShown = false;
  String? tapToRunMessage;

  @override
  Future<void> cancelReminder(String localWorkflowId) async {
    reminderCancelled = true;
  }

  @override
  Future<void> showDraftReady({
    required String localWorkflowId,
    required String runId,
  }) async {
    lastDraftReadyRunId = runId;
    lastDraftReadyAction = NotificationActions.review;
  }

  @override
  Future<void> showSkippedReview({
    required String localWorkflowId,
    required String runId,
  }) async {
    lastSkippedRunId = runId;
  }

  @override
  Future<void> showTapToRun({
    required String localWorkflowId,
    String? message,
  }) async {
    tapToRunShown = true;
    tapToRunMessage = message;
  }

  @override
  Future<void> scheduleReminder(WorkflowSchedule schedule) async {}
}

class RecordingScheduler extends WorkflowScheduler {
  RecordingScheduler({
    required super.scheduleRepository,
    required super.notifications,
  });

  int registerCount = 0;
  int cancelCount = 0;

  @override
  Future<void> registerSchedule(WorkflowSchedule schedule) async {
    registerCount++;
  }

  @override
  Future<void> cancelSchedule(String localWorkflowId) async {
    cancelCount++;
    await notifications.cancelReminder(localWorkflowId);
  }
}
