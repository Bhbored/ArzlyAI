// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_option_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModelOptionResponse _$ModelOptionResponseFromJson(Map<String, dynamic> json) =>
    _ModelOptionResponse(
      provider: json['provider'] as String,
      model: json['model'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$ModelOptionResponseToJson(
  _ModelOptionResponse instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'model': instance.model,
  'displayName': instance.displayName,
};
