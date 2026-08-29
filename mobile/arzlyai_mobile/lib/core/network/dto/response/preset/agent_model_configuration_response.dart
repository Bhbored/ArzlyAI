import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/model_option_response.dart';

part 'agent_model_configuration_response.freezed.dart';
part 'agent_model_configuration_response.g.dart';

@freezed
sealed class AgentModelConfigurationResponse
    with _$AgentModelConfigurationResponse {
  const factory AgentModelConfigurationResponse({
    required String provider,
    required String selectedModel,
    required List<ModelOptionResponse> availableModels,
    required bool isModelEditable,
    required double temperature,
    required double minimumTemperature,
    required double maximumTemperature,
    required bool isTemperatureEditable,
  }) = _AgentModelConfigurationResponse;

  factory AgentModelConfigurationResponse.fromJson(Map<String, dynamic> json) =>
      _$AgentModelConfigurationResponseFromJson(json);
}
