import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/result_contract_response.dart';

part 'workflow_node_response.freezed.dart';
part 'workflow_node_response.g.dart';

@freezed
sealed class WorkflowNodeResponse with _$WorkflowNodeResponse {
  const factory WorkflowNodeResponse({
    required String id,
    required String key,
    required String displayName,
    required String type,
    required int position,
    required bool requiresHumanApproval,
    String? configurationJson,
    ResultContractResponse? resultContract,
  }) = _WorkflowNodeResponse;

  factory WorkflowNodeResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkflowNodeResponseFromJson(json);
}
