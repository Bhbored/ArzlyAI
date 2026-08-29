import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_connection_response.freezed.dart';
part 'workflow_connection_response.g.dart';

@freezed
sealed class WorkflowConnectionResponse with _$WorkflowConnectionResponse {
  const factory WorkflowConnectionResponse({
    required String id,
    required String sourceNodeId,
    required String targetNodeId,
  }) = _WorkflowConnectionResponse;

  factory WorkflowConnectionResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkflowConnectionResponseFromJson(json);
}
