import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/enums/workflow_transport_state.dart';

part 'workflow_transport_provider.g.dart';

Duration? retry(int _, Object _) => null;

class WorkflowTransportStatus {
  const WorkflowTransportStatus({
    this.transport = WorkflowTransportState.idle,
    this.approvalInFlight = false,
    this.lockedApprovalNodeId,
    this.pendingLocalWorkflowId,
  });

  final WorkflowTransportState transport;
  final bool approvalInFlight;
  final String? lockedApprovalNodeId;
  final String? pendingLocalWorkflowId;

  bool get isProcessing =>
      transport == WorkflowTransportState.processing ||
      transport == WorkflowTransportState.reconciling;

  bool get blocksApproval => approvalInFlight || isProcessing;

  WorkflowTransportStatus copyWith({
    WorkflowTransportState? transport,
    bool? approvalInFlight,
    String? lockedApprovalNodeId,
    String? pendingLocalWorkflowId,
    bool clearLockedApprovalNodeId = false,
    bool clearPendingLocalWorkflowId = false,
  }) {
    return WorkflowTransportStatus(
      transport: transport ?? this.transport,
      approvalInFlight: approvalInFlight ?? this.approvalInFlight,
      lockedApprovalNodeId: clearLockedApprovalNodeId
          ? null
          : lockedApprovalNodeId ?? this.lockedApprovalNodeId,
      pendingLocalWorkflowId: clearPendingLocalWorkflowId
          ? null
          : pendingLocalWorkflowId ?? this.pendingLocalWorkflowId,
    );
  }
}

@Riverpod(keepAlive: true, retry: retry)
class WorkflowTransport extends _$WorkflowTransport {
  @override
  WorkflowTransportStatus build() => const WorkflowTransportStatus();

  void setInFlight({
    bool approval = false,
    String? approvalNodeId,
    String? pendingLocalWorkflowId,
  }) {
    state = state.copyWith(
      transport: WorkflowTransportState.inFlight,
      approvalInFlight: approval,
      lockedApprovalNodeId: approvalNodeId,
      pendingLocalWorkflowId: pendingLocalWorkflowId,
    );
  }

  void setProcessing() {
    state = state.copyWith(
      transport: WorkflowTransportState.processing,
      approvalInFlight: false,
    );
  }

  void setReconciling() {
    state = state.copyWith(
      transport: WorkflowTransportState.reconciling,
      approvalInFlight: false,
    );
  }

  void clearLockedApprovalIfWaiting(String? nodeId) {
    if (state.lockedApprovalNodeId == null) return;
    if (nodeId == null || state.lockedApprovalNodeId == nodeId) {
      state = state.copyWith(clearLockedApprovalNodeId: true);
    }
  }

  void clear() {
    state = const WorkflowTransportStatus();
  }
}
