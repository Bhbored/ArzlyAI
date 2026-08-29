// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_graph_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowGraphResponse _$WorkflowGraphResponseFromJson(
  Map<String, dynamic> json,
) => _WorkflowGraphResponse(
  key: json['key'] as String,
  nodes: (json['nodes'] as List<dynamic>)
      .map((e) => WorkflowNodeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  connections: (json['connections'] as List<dynamic>)
      .map(
        (e) => WorkflowConnectionResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$WorkflowGraphResponseToJson(
  _WorkflowGraphResponse instance,
) => <String, dynamic>{
  'key': instance.key,
  'nodes': instance.nodes.map((e) => e.toJson()).toList(),
  'connections': instance.connections.map((e) => e.toJson()).toList(),
};
