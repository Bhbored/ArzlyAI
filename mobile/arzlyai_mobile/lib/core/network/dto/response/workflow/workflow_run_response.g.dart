// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_run_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowRunResponse _$WorkflowRunResponseFromJson(Map<String, dynamic> json) =>
    _WorkflowRunResponse(
      runId: json['runId'] as String,
      presetKey: json['presetKey'] as String,
      status: json['status'] as String,
      nodes: (json['nodes'] as List<dynamic>)
          .map(
            (e) => WorkflowNodeRunResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      approval: json['approval'] == null
          ? null
          : ApprovalSnapshotResponse.fromJson(
              json['approval'] as Map<String, dynamic>,
            ),
      finalResponse: json['finalResponse'] as String?,
    );

Map<String, dynamic> _$WorkflowRunResponseToJson(
  _WorkflowRunResponse instance,
) => <String, dynamic>{
  'runId': instance.runId,
  'presetKey': instance.presetKey,
  'status': instance.status,
  'nodes': instance.nodes.map((e) => e.toJson()).toList(),
  'approval': instance.approval?.toJson(),
  'finalResponse': instance.finalResponse,
};
