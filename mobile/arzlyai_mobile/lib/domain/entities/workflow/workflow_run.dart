import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';

part 'workflow_run.freezed.dart';

@freezed
sealed class RenderedWorkflowResult with _$RenderedWorkflowResult {
  const factory RenderedWorkflowResult({
    required String mediaType,
    required String content,
  }) = _RenderedWorkflowResult;
}

@freezed
sealed class ApprovalSnapshot with _$ApprovalSnapshot {
  const factory ApprovalSnapshot({
    required String originalContent,
    required String currentContent,
    required bool wasEdited,
  }) = _ApprovalSnapshot;
}

@freezed
sealed class WorkflowNodeRun with _$WorkflowNodeRun {
  const factory WorkflowNodeRun({
    required String nodeId,
    required String nodeKey,
    required String displayName,
    required String type,
    required WorkflowNodeStatus status,
    required bool isRunning,
    String? output,
    String? error,
    String? effectiveProvider,
    String? effectiveModel,
    double? effectiveTemperature,
    DateTime? updatedAtUtc,
  }) = _WorkflowNodeRun;
}

@freezed
sealed class WorkflowRun with _$WorkflowRun {
  const factory WorkflowRun({
    required String runId,
    required String presetKey,
    required WorkflowRunStatus status,
    required List<WorkflowNodeRun> nodes,
    ApprovalSnapshot? approval,
    String? finalResponse,
    ArzlyReport? report,
    RenderedWorkflowResult? renderedResult,
    ResultContract? resultContract,
    String? localWorkflowId,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    DateTime? expiryUtc,
  }) = _WorkflowRun;
}

@freezed
sealed class WorkflowInstance with _$WorkflowInstance {
  const factory WorkflowInstance({
    required String id,
    required String presetKey,
    required int presetVersion,
    required String name,
    required String topic,
    String? modelOverridesJson,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
  }) = _WorkflowInstance;
}

@freezed
sealed class WorkflowNodeChanged with _$WorkflowNodeChanged {
  const factory WorkflowNodeChanged({
    required String runId,
    required String nodeId,
    required String nodeKey,
    required WorkflowNodeStatus status,
    required bool isRunning,
    required String message,
    required DateTime occurredAtUtc,
  }) = _WorkflowNodeChanged;
}
