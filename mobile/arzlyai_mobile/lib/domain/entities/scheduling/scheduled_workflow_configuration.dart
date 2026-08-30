import 'package:arzlyai_mobile/domain/entities/scheduling/schedule_recurrence.dart';

class ScheduledWorkflowConfiguration {
  const ScheduledWorkflowConfiguration({
    required this.recurrence,
    required this.inputs,
    required this.presetName,
  });

  final ScheduleRecurrence recurrence;
  final Map<String, String> inputs;
  final String presetName;
}
