// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_harness_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentHarnessResponse _$AgentHarnessResponseFromJson(
  Map<String, dynamic> json,
) => _AgentHarnessResponse(
  planningEnabled: json['planningEnabled'] as bool,
  todoTrackingEnabled: json['todoTrackingEnabled'] as bool,
  contextCompactionEnabled: json['contextCompactionEnabled'] as bool,
  requiresToolApproval: json['requiresToolApproval'] as bool,
  maximumIterations: (json['maximumIterations'] as num).toInt(),
  webSearchEnabled: json['webSearchEnabled'] as bool? ?? false,
);

Map<String, dynamic> _$AgentHarnessResponseToJson(
  _AgentHarnessResponse instance,
) => <String, dynamic>{
  'planningEnabled': instance.planningEnabled,
  'todoTrackingEnabled': instance.todoTrackingEnabled,
  'contextCompactionEnabled': instance.contextCompactionEnabled,
  'requiresToolApproval': instance.requiresToolApproval,
  'maximumIterations': instance.maximumIterations,
  'webSearchEnabled': instance.webSearchEnabled,
};
