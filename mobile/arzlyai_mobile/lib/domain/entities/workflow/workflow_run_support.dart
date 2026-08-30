import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';

extension WorkflowRunSupport on WorkflowRun {
  int? waitingApprovalIndex() {
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].status == WorkflowNodeStatus.waitingForApproval) return i;
    }
    return null;
  }

  bool hasRemainingWorkAfterApproval(int approvalIndex) {
    for (var i = approvalIndex + 1; i < nodes.length; i++) {
      final type = nodes[i].type;
      if (type == 'Agent' || type == 'Integration' || type == 'Operation') {
        return true;
      }
    }
    return false;
  }

  bool hasRemainingIntegrationAfterApproval(int approvalIndex) {
    for (var i = approvalIndex + 1; i < nodes.length; i++) {
      if (nodes[i].type == 'Integration') return true;
    }
    return false;
  }
}
