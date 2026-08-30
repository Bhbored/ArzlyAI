// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openai_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpenAiModelResponse _$OpenAiModelResponseFromJson(Map<String, dynamic> json) =>
    _OpenAiModelResponse(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      ownedBy: json['ownedBy'] as String,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      supportsTemperature: json['supportsTemperature'] as bool,
      supportsWebSearch: json['supportsWebSearch'] as bool? ?? false,
    );

Map<String, dynamic> _$OpenAiModelResponseToJson(
  _OpenAiModelResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'ownedBy': instance.ownedBy,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'supportsTemperature': instance.supportsTemperature,
  'supportsWebSearch': instance.supportsWebSearch,
};
