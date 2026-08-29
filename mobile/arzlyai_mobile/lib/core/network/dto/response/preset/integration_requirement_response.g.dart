// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_requirement_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IntegrationRequirementResponse _$IntegrationRequirementResponseFromJson(
  Map<String, dynamic> json,
) => _IntegrationRequirementResponse(
  key: json['key'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  credentialSchemaJson: json['credentialSchemaJson'] as String,
);

Map<String, dynamic> _$IntegrationRequirementResponseToJson(
  _IntegrationRequirementResponse instance,
) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name,
  'description': instance.description,
  'credentialSchemaJson': instance.credentialSchemaJson,
};
