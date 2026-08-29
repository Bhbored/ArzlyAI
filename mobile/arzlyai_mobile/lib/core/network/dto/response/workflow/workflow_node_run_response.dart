import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_node_run_response.freezed.dart';
part 'workflow_node_run_response.g.dart';

@freezed
sealed class WorkflowNodeRunResponse with _$WorkflowNodeRunResponse {
  const factory WorkflowNodeRunResponse({
    required String nodeId,
    required String nodeKey,
    required String displayName,
    required String type,
    required String status,
    required bool isRunning,
    String? output,
    String? error,
  }) = _WorkflowNodeRunResponse;

  factory WorkflowNodeRunResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkflowNodeRunResponseFromJson(json);
}
