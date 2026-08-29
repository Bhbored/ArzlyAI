import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_workflow_request.freezed.dart';
part 'schedule_workflow_request.g.dart';

@freezed
sealed class ScheduleWorkflowRequest with _$ScheduleWorkflowRequest {
  const factory ScheduleWorkflowRequest({
    required String localTime,
    required String timeZoneId,
  }) = _ScheduleWorkflowRequest;

  factory ScheduleWorkflowRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleWorkflowRequestFromJson(json);
}
