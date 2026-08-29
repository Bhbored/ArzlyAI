// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_node_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowNodeResponse _$WorkflowNodeResponseFromJson(
  Map<String, dynamic> json,
) => _WorkflowNodeResponse(
  id: json['id'] as String,
  key: json['key'] as String,
  displayName: json['displayName'] as String,
  type: json['type'] as String,
  position: (json['position'] as num).toInt(),
  requiresHumanApproval: json['requiresHumanApproval'] as bool,
);

Map<String, dynamic> _$WorkflowNodeResponseToJson(
  _WorkflowNodeResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'displayName': instance.displayName,
  'type': instance.type,
  'position': instance.position,
  'requiresHumanApproval': instance.requiresHumanApproval,
};
