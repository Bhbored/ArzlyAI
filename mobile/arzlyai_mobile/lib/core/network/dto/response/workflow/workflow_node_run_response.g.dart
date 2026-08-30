// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_node_run_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowNodeRunResponse _$WorkflowNodeRunResponseFromJson(
  Map<String, dynamic> json,
) => _WorkflowNodeRunResponse(
  nodeId: json['nodeId'] as String,
  nodeKey: json['nodeKey'] as String,
  displayName: json['displayName'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  isRunning: json['isRunning'] as bool,
  output: json['output'] as String?,
  error: json['error'] as String?,
  effectiveProvider: json['effectiveProvider'] as String?,
  effectiveModel: json['effectiveModel'] as String?,
  effectiveTemperature: (json['effectiveTemperature'] as num?)?.toDouble(),
);

Map<String, dynamic> _$WorkflowNodeRunResponseToJson(
  _WorkflowNodeRunResponse instance,
) => <String, dynamic>{
  'nodeId': instance.nodeId,
  'nodeKey': instance.nodeKey,
  'displayName': instance.displayName,
  'type': instance.type,
  'status': instance.status,
  'isRunning': instance.isRunning,
  'output': instance.output,
  'error': instance.error,
  'effectiveProvider': instance.effectiveProvider,
  'effectiveModel': instance.effectiveModel,
  'effectiveTemperature': instance.effectiveTemperature,
};
