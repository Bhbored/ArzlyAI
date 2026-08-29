// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresetDetailsResponse _$PresetDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _PresetDetailsResponse(
  id: json['id'] as String,
  key: json['key'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  version: (json['version'] as num).toInt(),
  agents: (json['agents'] as List<dynamic>)
      .map((e) => AgentResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  workflow: WorkflowGraphResponse.fromJson(
    json['workflow'] as Map<String, dynamic>,
  ),
  integrations: (json['integrations'] as List<dynamic>)
      .map(
        (e) =>
            IntegrationRequirementResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$PresetDetailsResponseToJson(
  _PresetDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'name': instance.name,
  'description': instance.description,
  'version': instance.version,
  'agents': instance.agents.map((e) => e.toJson()).toList(),
  'workflow': instance.workflow.toJson(),
  'integrations': instance.integrations.map((e) => e.toJson()).toList(),
};
