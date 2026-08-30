// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_configuration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentModelConfigurationResponse _$AgentModelConfigurationResponseFromJson(
  Map<String, dynamic> json,
) => _AgentModelConfigurationResponse(
  provider: json['provider'] as String,
  selectedModel: json['selectedModel'] as String,
  availableModels: (json['availableModels'] as List<dynamic>)
      .map((e) => ModelOptionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  isModelEditable: json['isModelEditable'] as bool,
  temperature: (json['temperature'] as num).toDouble(),
  minimumTemperature: (json['minimumTemperature'] as num).toDouble(),
  maximumTemperature: (json['maximumTemperature'] as num).toDouble(),
  isTemperatureEditable: json['isTemperatureEditable'] as bool,
  supportsWebSearch: json['supportsWebSearch'] as bool? ?? false,
);

Map<String, dynamic> _$AgentModelConfigurationResponseToJson(
  _AgentModelConfigurationResponse instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'selectedModel': instance.selectedModel,
  'availableModels': instance.availableModels.map((e) => e.toJson()).toList(),
  'isModelEditable': instance.isModelEditable,
  'temperature': instance.temperature,
  'minimumTemperature': instance.minimumTemperature,
  'maximumTemperature': instance.maximumTemperature,
  'isTemperatureEditable': instance.isTemperatureEditable,
  'supportsWebSearch': instance.supportsWebSearch,
};
