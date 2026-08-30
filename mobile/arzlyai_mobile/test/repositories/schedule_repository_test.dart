import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_outcomes.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/schedule_recurrence.dart';

void main() {
  late AppDatabase db;
  late ScheduleRepository repository;

  setUp(() {
    tz_data.initializeTimeZones();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ScheduleRepository(db, const ScheduleOccurrenceCalculator());
  });

  tearDown(() async {
    await db.close();
  });

  test('tryClaimOccurrence claims once per occurrence', () async {
    final next = DateTime.now().toUtc().subtract(const Duration(minutes: 1));
    await repository.upsert(
      localWorkflowId: 'wf-1',
      localTime: '08:00',
      timeZoneId: 'UTC',
      enabled: true,
      nextRunAtUtc: next,
    );

    expect(await repository.tryClaimOccurrence('wf-1'), isTrue);
    expect(await repository.tryClaimOccurrence('wf-1'), isFalse);

    await repository.recordSuccess(
      localWorkflowId: 'wf-1',
      outcome: ScheduleOutcomes.waitingForUser,
    );
    expect(await repository.tryClaimOccurrence('wf-1'), isFalse);
  });

  test('upsert replaces schedule for same workflow id', () async {
    await repository.upsert(
      localWorkflowId: 'wf-1',
      localTime: '08:00',
      timeZoneId: 'UTC',
      enabled: true,
    );
    await repository.upsert(
      localWorkflowId: 'wf-1',
      localTime: '09:30',
      timeZoneId: 'UTC',
      enabled: true,
    );
    final schedule = await repository.getByWorkflowId('wf-1');
    expect(schedule?.localTime, '09:30');
  });

  test(
    'upsert persists complete inputs and recurrence configuration',
    () async {
      final recurrence = ScheduleRecurrence(
        type: ScheduleRecurrenceType.quarterly,
        anchorDate: DateTime(2026, 2, 28),
      );
      await repository.upsert(
        localWorkflowId: 'receipt-1',
        localTime: '07:15',
        timeZoneId: 'America/New_York',
        enabled: true,
        recurrence: recurrence,
        workflowInputs: const {
          'spreadsheetId': 'sheet-1',
          'sourceRange': "'Receipts'!A:Z",
          'columnMappingJson': '{"date":"Date"}',
          'deliveryMode': 'deliver',
        },
        presetName: 'Quarterly Receipt Tax',
      );

      final configuration = await repository.getConfiguration('receipt-1');

      expect(configuration?.recurrence.type, ScheduleRecurrenceType.quarterly);
      expect(configuration?.recurrence.anchorDate, DateTime(2026, 2, 28));
      expect(configuration?.inputs['spreadsheetId'], 'sheet-1');
      expect(configuration?.inputs['deliveryMode'], 'deliver');
      expect(configuration?.presetName, 'Quarterly Receipt Tax');
    },
  );

  test('recordSuccess advances using stored recurrence', () async {
    await repository.upsert(
      localWorkflowId: 'wf-monthly',
      localTime: '08:00',
      timeZoneId: 'UTC',
      enabled: true,
      recurrence: ScheduleRecurrence(
        type: ScheduleRecurrenceType.monthly,
        anchorDate: DateTime(2026, 1, 31),
      ),
      nextRunAtUtc: DateTime.utc(2026, 1, 31, 8),
    );

    await repository.recordSuccess(
      localWorkflowId: 'wf-monthly',
      outcome: ScheduleOutcomes.started,
      succeededAtUtc: DateTime.utc(2026, 1, 31, 9),
    );

    final schedule = await repository.getByWorkflowId('wf-monthly');
    expect(schedule?.nextRunAtUtc.toUtc(), DateTime.utc(2026, 2, 28, 8));
  });
}
