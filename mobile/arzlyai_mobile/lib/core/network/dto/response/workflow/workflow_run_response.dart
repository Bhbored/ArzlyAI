import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/approval_snapshot_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/rendered_workflow_result_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_node_run_response.dart';

part 'workflow_run_response.freezed.dart';
part 'workflow_run_response.g.dart';

@freezed
sealed class WorkflowRunResponse with _$WorkflowRunResponse {
  const factory WorkflowRunResponse({
    required String runId,
    required String presetKey,
    required String status,
    required List<WorkflowNodeRunResponse> nodes,
    ApprovalSnapshotResponse? approval,
    String? finalResponse,
    Map<String, dynamic>? resultDocument,
    RenderedWorkflowResultResponse? renderedResult,
  }) = _WorkflowRunResponse;

  factory WorkflowRunResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkflowRunResponseFromJson(json);
}
