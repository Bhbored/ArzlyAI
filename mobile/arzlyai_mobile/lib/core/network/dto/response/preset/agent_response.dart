import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/agent_harness_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/agent_model_configuration_response.dart';

part 'agent_response.freezed.dart';
part 'agent_response.g.dart';

@freezed
sealed class AgentResponse with _$AgentResponse {
  const factory AgentResponse({
    required String key,
    required String name,
    required String systemPrompt,
    required bool isSystemPromptEditable,
    required AgentModelConfigurationResponse modelConfiguration,
    required AgentHarnessResponse harness,
  }) = _AgentResponse;

  factory AgentResponse.fromJson(Map<String, dynamic> json) =>
      _$AgentResponseFromJson(json);
}
