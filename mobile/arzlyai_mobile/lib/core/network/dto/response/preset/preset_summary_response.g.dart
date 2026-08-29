// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresetSummaryResponse _$PresetSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _PresetSummaryResponse(
  id: json['id'] as String,
  key: json['key'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$PresetSummaryResponseToJson(
  _PresetSummaryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'name': instance.name,
  'description': instance.description,
  'version': instance.version,
};
