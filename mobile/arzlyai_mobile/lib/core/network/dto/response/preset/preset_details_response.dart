import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/agent_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/integration_requirement_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/workflow_graph_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/result_contract_response.dart';

part 'preset_details_response.freezed.dart';
part 'preset_details_response.g.dart';

@freezed
sealed class PresetDetailsResponse with _$PresetDetailsResponse {
  const factory PresetDetailsResponse({
    required String id,
    required String key,
    required String name,
    required String description,
    required int version,
    required List<AgentResponse> agents,
    required WorkflowGraphResponse workflow,
    required List<IntegrationRequirementResponse> integrations,
    String? inputSchemaJson,
    ResultContractResponse? resultContract,
  }) = _PresetDetailsResponse;

  factory PresetDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$PresetDetailsResponseFromJson(json);
}
