// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_workflow_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StartWorkflowRequest _$StartWorkflowRequestFromJson(
  Map<String, dynamic> json,
) => _StartWorkflowRequest(
  presetKey: json['presetKey'] as String,
  inputs: Map<String, String>.from(json['inputs'] as Map),
  agentOverrides: (json['agentOverrides'] as List<dynamic>)
      .map((e) => AgentOverrideRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  credentials: CredentialEnvelope.fromJson(
    json['credentials'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$StartWorkflowRequestToJson(
  _StartWorkflowRequest instance,
) => <String, dynamic>{
  'presetKey': instance.presetKey,
  'inputs': instance.inputs,
  'agentOverrides': instance.agentOverrides.map((e) => e.toJson()).toList(),
  'credentials': instance.credentials.toJson(),
};
