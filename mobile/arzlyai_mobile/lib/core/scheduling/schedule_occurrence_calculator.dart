import 'package:timezone/timezone.dart' as tz;

class ScheduleOccurrenceCalculator {
  const ScheduleOccurrenceCalculator();

  DateTime nextOccurrenceUtc({
    required String localTime,
    required String timeZoneId,
    DateTime? afterUtc,
  }) {
    final parts = localTime.split(':');
    if (parts.length != 2) {
      throw ArgumentError('localTime must be HH:mm');
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw ArgumentError('localTime must be a valid wall-clock time');
    }

    final location = tz.getLocation(timeZoneId);
    final after = afterUtc ?? DateTime.now().toUtc();
    var candidate = tz.TZDateTime(
      location,
      after.year,
      after.month,
      after.day,
      hour,
      minute,
    );
    if (!candidate.isAfter(after)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate.toUtc();
  }
}
