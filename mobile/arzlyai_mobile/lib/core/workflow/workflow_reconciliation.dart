import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';

const reconcileBackoffSeconds = [2, 4, 8, 15];

bool isReconcileTerminal(WorkflowRunStatus status) {
  return status == WorkflowRunStatus.waitingForApproval ||
      status == WorkflowRunStatus.completed ||
      status == WorkflowRunStatus.failed ||
      status == WorkflowRunStatus.cancelled;
}

bool shouldRefetchRunSnapshotForNode(
  WorkflowRun run,
  WorkflowNodeChanged event,
) {
  if (event.nodeKey == 'report-composer') return true;
  final node = run.nodes.where((n) => n.nodeId == event.nodeId).firstOrNull;
  return node?.type == 'HumanApproval';
}
