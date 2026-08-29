import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/workflow_connection_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/workflow_node_response.dart';

part 'workflow_graph_response.freezed.dart';
part 'workflow_graph_response.g.dart';

@freezed
sealed class WorkflowGraphResponse with _$WorkflowGraphResponse {
  const factory WorkflowGraphResponse({
    required String key,
    required List<WorkflowNodeResponse> nodes,
    required List<WorkflowConnectionResponse> connections,
  }) = _WorkflowGraphResponse;

  factory WorkflowGraphResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkflowGraphResponseFromJson(json);
}
