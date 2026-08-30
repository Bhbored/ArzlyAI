import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/schedule_recurrence.dart';

void main() {
  setUp(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/New_York'));
  });

  const calculator = ScheduleOccurrenceCalculator();

  test('nextOccurrenceUtc returns future instant for wall clock time', () {
    final after = DateTime.utc(2026, 3, 1, 12, 0);
    final next = calculator.nextOccurrenceUtc(
      localTime: '08:00',
      timeZoneId: 'America/New_York',
      afterUtc: after,
    );
    expect(next.isAfter(after), isTrue);
  });

  test('nextOccurrenceUtc rolls to next day when time passed', () {
    final after = DateTime.utc(2026, 3, 1, 20, 0);
    final next = calculator.nextOccurrenceUtc(
      localTime: '08:00',
      timeZoneId: 'America/New_York',
      afterUtc: after,
    );
    expect(next.day, 2);
  });

  test('weekly recurrence keeps anchor weekday in its timezone', () {
    final next = calculator.nextOccurrenceUtc(
      localTime: '08:00',
      timeZoneId: 'America/New_York',
      recurrence: ScheduleRecurrence(
        type: ScheduleRecurrenceType.weekly,
        anchorDate: DateTime(2026, 3, 2),
      ),
      afterUtc: DateTime.utc(2026, 3, 3),
    );
    final local = tz.TZDateTime.from(next, tz.getLocation('America/New_York'));
    expect(local.weekday, DateTime.monday);
    expect(local.hour, 8);
  });

  test('monthly recurrence clamps end of month', () {
    final next = calculator.nextOccurrenceUtc(
      localTime: '08:00',
      timeZoneId: 'UTC',
      recurrence: ScheduleRecurrence(
        type: ScheduleRecurrenceType.monthly,
        anchorDate: DateTime(2026, 1, 31),
      ),
      afterUtc: DateTime.utc(2026, 2, 1),
    );
    expect(next, DateTime.utc(2026, 2, 28, 8));
  });

  test('quarterly and yearly recurrences preserve anchor month and day', () {
    final quarterly = calculator.nextOccurrenceUtc(
      localTime: '10:30',
      timeZoneId: 'UTC',
      recurrence: ScheduleRecurrence(
        type: ScheduleRecurrenceType.quarterly,
        anchorDate: DateTime(2026, 2, 15),
      ),
      afterUtc: DateTime.utc(2026, 3, 1),
    );
    final yearly = calculator.nextOccurrenceUtc(
      localTime: '10:30',
      timeZoneId: 'UTC',
      recurrence: ScheduleRecurrence(
        type: ScheduleRecurrenceType.yearly,
        anchorDate: DateTime(2024, 2, 29),
      ),
      afterUtc: DateTime.utc(2026, 3, 1),
    );
    expect(quarterly, DateTime.utc(2026, 5, 15, 10, 30));
    expect(yearly, DateTime.utc(2027, 2, 28, 10, 30));
  });

  test('custom recurrence runs every configured number of days', () {
    final next = calculator.nextOccurrenceUtc(
      localTime: '06:00',
      timeZoneId: 'UTC',
      recurrence: ScheduleRecurrence(
        type: ScheduleRecurrenceType.custom,
        anchorDate: DateTime(2026, 1, 1),
        customIntervalDays: 10,
      ),
      afterUtc: DateTime.utc(2026, 1, 2),
    );
    expect(next, DateTime.utc(2026, 1, 11, 6));
  });

  test('daily recurrence handles DST using local wall clock time', () {
    final next = calculator.nextOccurrenceUtc(
      localTime: '08:00',
      timeZoneId: 'America/New_York',
      afterUtc: DateTime.utc(2026, 3, 8, 11),
    );
    expect(next, DateTime.utc(2026, 3, 8, 12));
  });
}
