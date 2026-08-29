import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_schedule.freezed.dart';

@freezed
sealed class WorkflowSchedule with _$WorkflowSchedule {
  const factory WorkflowSchedule({
    required String localWorkflowId,
    required String localTime,
    required String timeZoneId,
    required bool enabled,
    String? platformTaskId,
    required DateTime nextRunAtUtc,
    DateTime? lastAttemptAtUtc,
    DateTime? lastSucceededAtUtc,
    String? lastOutcome,
    String? failureMessage,
  }) = _WorkflowSchedule;
}
