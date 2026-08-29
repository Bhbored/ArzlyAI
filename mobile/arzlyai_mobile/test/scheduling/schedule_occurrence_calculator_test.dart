import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';

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
}
