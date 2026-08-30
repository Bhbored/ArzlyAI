enum ScheduleRecurrenceType {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom,
}

class ScheduleRecurrence {
  const ScheduleRecurrence({
    required this.type,
    required this.anchorDate,
    this.customIntervalDays = 1,
  });

  final ScheduleRecurrenceType type;
  final DateTime anchorDate;
  final int customIntervalDays;

  factory ScheduleRecurrence.daily({DateTime? anchorDate}) {
    final date = anchorDate ?? DateTime.now();
    return ScheduleRecurrence(
      type: ScheduleRecurrenceType.daily,
      anchorDate: DateTime(date.year, date.month, date.day),
    );
  }

  factory ScheduleRecurrence.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? 'daily';
    final type = ScheduleRecurrenceType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => ScheduleRecurrenceType.daily,
    );
    final parsedAnchor = DateTime.tryParse(json['anchorDate'] as String? ?? '');
    return ScheduleRecurrence(
      type: type,
      anchorDate: parsedAnchor ?? DateTime.now(),
      customIntervalDays: (json['customIntervalDays'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'anchorDate':
        '${anchorDate.year.toString().padLeft(4, '0')}-'
        '${anchorDate.month.toString().padLeft(2, '0')}-'
        '${anchorDate.day.toString().padLeft(2, '0')}',
    'customIntervalDays': customIntervalDays,
  };
}
