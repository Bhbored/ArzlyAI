// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_node_changed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowNodeChangedEvent _$WorkflowNodeChangedEventFromJson(
  Map<String, dynamic> json,
) => _WorkflowNodeChangedEvent(
  runId: json['runId'] as String,
  nodeId: json['nodeId'] as String,
  nodeKey: json['nodeKey'] as String,
  status: json['status'] as String,
  isRunning: json['isRunning'] as bool,
  message: json['message'] as String,
  occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
);

Map<String, dynamic> _$WorkflowNodeChangedEventToJson(
  _WorkflowNodeChangedEvent instance,
) => <String, dynamic>{
  'runId': instance.runId,
  'nodeId': instance.nodeId,
  'nodeKey': instance.nodeKey,
  'status': instance.status,
  'isRunning': instance.isRunning,
  'message': instance.message,
  'occurredAtUtc': instance.occurredAtUtc.toIso8601String(),
};
