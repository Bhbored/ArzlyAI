// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_override_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentOverrideRequest _$AgentOverrideRequestFromJson(
  Map<String, dynamic> json,
) => _AgentOverrideRequest(
  agentKey: json['agentKey'] as String,
  provider: json['provider'] as String?,
  model: json['model'] as String?,
  temperature: (json['temperature'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AgentOverrideRequestToJson(
  _AgentOverrideRequest instance,
) => <String, dynamic>{
  'agentKey': instance.agentKey,
  'provider': instance.provider,
  'model': instance.model,
  'temperature': instance.temperature,
};
