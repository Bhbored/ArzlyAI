// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentResponse _$AgentResponseFromJson(Map<String, dynamic> json) =>
    _AgentResponse(
      key: json['key'] as String,
      name: json['name'] as String,
      systemPrompt: json['systemPrompt'] as String,
      isSystemPromptEditable: json['isSystemPromptEditable'] as bool,
      modelConfiguration: AgentModelConfigurationResponse.fromJson(
        json['modelConfiguration'] as Map<String, dynamic>,
      ),
      harness: AgentHarnessResponse.fromJson(
        json['harness'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AgentResponseToJson(_AgentResponse instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'systemPrompt': instance.systemPrompt,
      'isSystemPromptEditable': instance.isSystemPromptEditable,
      'modelConfiguration': instance.modelConfiguration.toJson(),
      'harness': instance.harness.toJson(),
    };
