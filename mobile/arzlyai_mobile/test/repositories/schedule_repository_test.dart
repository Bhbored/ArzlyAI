import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_outcomes.dart';
import 'package:arzlyai_mobile/data/repositories/schedule_repository.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

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
}
