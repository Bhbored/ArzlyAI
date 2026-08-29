import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/approval_snapshot_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_node_changed_event.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_node_run_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';

class WorkflowRunMapper {
  const WorkflowRunMapper();

  WorkflowRun fromDto(
    WorkflowRunResponse dto, {
    String? localWorkflowId,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    DateTime? expiryUtc,
  }) {
    return WorkflowRun(
      runId: dto.runId,
      presetKey: dto.presetKey,
      status: WorkflowRunStatusX.parse(dto.status),
      nodes: dto.nodes.map(_node).toList(),
      approval: dto.approval == null ? null : _approval(dto.approval!),
      finalResponse: dto.finalResponse,
      localWorkflowId: localWorkflowId,
      createdAtUtc: createdAtUtc,
      updatedAtUtc: updatedAtUtc,
      expiryUtc: expiryUtc,
    );
  }

  WorkflowNodeChanged eventFromDto(WorkflowNodeChangedEvent dto) {
    return WorkflowNodeChanged(
      runId: dto.runId,
      nodeId: dto.nodeId,
      nodeKey: dto.nodeKey,
      status: WorkflowNodeStatusX.parse(dto.status),
      isRunning: dto.isRunning,
      message: dto.message,
      occurredAtUtc: dto.occurredAtUtc.toUtc(),
    );
  }

  WorkflowRun mergeEvent(WorkflowRun run, WorkflowNodeChanged event) {
    final nodes = [
      for (final node in run.nodes)
        if (node.nodeId != event.nodeId)
          node
        else if (node.updatedAtUtc != null &&
            !event.occurredAtUtc.isAfter(node.updatedAtUtc!))
          node
        else
          node.copyWith(
            status: event.status,
            isRunning: event.isRunning,
            updatedAtUtc: event.occurredAtUtc,
          ),
    ];
    return run.copyWith(nodes: nodes, updatedAtUtc: event.occurredAtUtc);
  }

  WorkflowNodeRun _node(WorkflowNodeRunResponse dto) {
    return WorkflowNodeRun(
      nodeId: dto.nodeId,
      nodeKey: dto.nodeKey,
      displayName: dto.displayName,
      type: dto.type,
      status: WorkflowNodeStatusX.parse(dto.status),
      isRunning: dto.isRunning,
      output: dto.output,
      error: dto.error,
    );
  }

  ApprovalSnapshot _approval(ApprovalSnapshotResponse dto) {
    return ApprovalSnapshot(
      originalContent: dto.originalContent,
      currentContent: dto.currentContent,
      wasEdited: dto.wasEdited,
    );
  }
}
