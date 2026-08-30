// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderModelResponse _$ProviderModelResponseFromJson(
  Map<String, dynamic> json,
) => _ProviderModelResponse(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  provider: json['provider'] as String,
  ownedBy: json['ownedBy'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  supportsTemperature: json['supportsTemperature'] as bool,
  supportsWebSearch: json['supportsWebSearch'] as bool? ?? false,
);

Map<String, dynamic> _$ProviderModelResponseToJson(
  _ProviderModelResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'provider': instance.provider,
  'ownedBy': instance.ownedBy,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'supportsTemperature': instance.supportsTemperature,
  'supportsWebSearch': instance.supportsWebSearch,
};
