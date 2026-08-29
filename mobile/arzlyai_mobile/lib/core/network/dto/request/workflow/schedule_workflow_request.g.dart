// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_workflow_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleWorkflowRequest _$ScheduleWorkflowRequestFromJson(
  Map<String, dynamic> json,
) => _ScheduleWorkflowRequest(
  localTime: json['localTime'] as String,
  timeZoneId: json['timeZoneId'] as String,
);

Map<String, dynamic> _$ScheduleWorkflowRequestToJson(
  _ScheduleWorkflowRequest instance,
) => <String, dynamic>{
  'localTime': instance.localTime,
  'timeZoneId': instance.timeZoneId,
};
