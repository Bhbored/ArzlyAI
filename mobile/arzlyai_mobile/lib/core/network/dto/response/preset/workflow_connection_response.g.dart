// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_connection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowConnectionResponse _$WorkflowConnectionResponseFromJson(
  Map<String, dynamic> json,
) => _WorkflowConnectionResponse(
  id: json['id'] as String,
  sourceNodeId: json['sourceNodeId'] as String,
  targetNodeId: json['targetNodeId'] as String,
);

Map<String, dynamic> _$WorkflowConnectionResponseToJson(
  _WorkflowConnectionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceNodeId': instance.sourceNodeId,
  'targetNodeId': instance.targetNodeId,
};
