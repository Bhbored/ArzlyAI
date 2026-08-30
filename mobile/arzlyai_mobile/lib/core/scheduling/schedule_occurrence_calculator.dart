import 'package:timezone/timezone.dart' as tz;
import 'package:arzlyai_mobile/domain/entities/scheduling/schedule_recurrence.dart';

class ScheduleOccurrenceCalculator {
  const ScheduleOccurrenceCalculator();

  DateTime nextOccurrenceUtc({
    required String localTime,
    required String timeZoneId,
    ScheduleRecurrence? recurrence,
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
    final localAfter = tz.TZDateTime.from(after, location);
    final rule = recurrence ?? ScheduleRecurrence.daily(anchorDate: localAfter);
    var date = DateTime(localAfter.year, localAfter.month, localAfter.day);
    final anchor = DateTime(
      rule.anchorDate.year,
      rule.anchorDate.month,
      rule.anchorDate.day,
    );
    if (date.isBefore(anchor)) date = anchor;
    if (rule.type == ScheduleRecurrenceType.custom) {
      date = _nextCustomDate(date, anchor, rule.customIntervalDays);
    }
    for (var attempts = 0; attempts < 370; attempts++) {
      if (_matches(date, rule)) {
        final candidate = tz.TZDateTime(
          location,
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );
        if (candidate.isAfter(after)) return candidate.toUtc();
        if (rule.type == ScheduleRecurrenceType.custom) {
          date = date.add(Duration(days: rule.customIntervalDays));
          continue;
        }
      }
      date = date.add(const Duration(days: 1));
    }
    throw StateError('Could not calculate the next schedule occurrence.');
  }

  bool _matches(DateTime date, ScheduleRecurrence recurrence) {
    final anchor = DateTime(
      recurrence.anchorDate.year,
      recurrence.anchorDate.month,
      recurrence.anchorDate.day,
    );
    final days = date.difference(anchor).inDays;
    if (days < 0) return false;
    switch (recurrence.type) {
      case ScheduleRecurrenceType.daily:
        return true;
      case ScheduleRecurrenceType.weekly:
        return date.weekday == anchor.weekday;
      case ScheduleRecurrenceType.monthly:
        return date.day == _clampedDay(anchor.day, date.year, date.month);
      case ScheduleRecurrenceType.quarterly:
        final months =
            (date.year - anchor.year) * 12 + date.month - anchor.month;
        return months >= 0 &&
            months % 3 == 0 &&
            date.day == _clampedDay(anchor.day, date.year, date.month);
      case ScheduleRecurrenceType.yearly:
        return date.month == anchor.month &&
            date.day == _clampedDay(anchor.day, date.year, anchor.month);
      case ScheduleRecurrenceType.custom:
        if (recurrence.customIntervalDays < 1) {
          throw ArgumentError('customIntervalDays must be at least 1');
        }
        return days % recurrence.customIntervalDays == 0;
    }
  }

  int _clampedDay(int requestedDay, int year, int month) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return requestedDay > lastDay ? lastDay : requestedDay;
  }

  DateTime _nextCustomDate(DateTime date, DateTime anchor, int intervalDays) {
    if (intervalDays < 1) {
      throw ArgumentError('customIntervalDays must be at least 1');
    }
    final elapsedDays = date.difference(anchor).inDays;
    final remainder = elapsedDays % intervalDays;
    return remainder == 0
        ? date
        : date.add(Duration(days: intervalDays - remainder));
  }
}
