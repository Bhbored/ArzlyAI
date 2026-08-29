enum WorkflowNodeStatus {
  idle,
  running,
  waitingForApproval,
  completed,
  failed,
  skipped,
  unknown,
}

extension WorkflowNodeStatusX on WorkflowNodeStatus {
  static WorkflowNodeStatus parse(String? value) {
    return switch (value) {
      'Idle' => WorkflowNodeStatus.idle,
      'Running' => WorkflowNodeStatus.running,
      'WaitingForApproval' => WorkflowNodeStatus.waitingForApproval,
      'Completed' => WorkflowNodeStatus.completed,
      'Failed' => WorkflowNodeStatus.failed,
      'Skipped' => WorkflowNodeStatus.skipped,
      _ => WorkflowNodeStatus.unknown,
    };
  }

  String get wireValue => switch (this) {
    WorkflowNodeStatus.idle => 'Idle',
    WorkflowNodeStatus.running => 'Running',
    WorkflowNodeStatus.waitingForApproval => 'WaitingForApproval',
    WorkflowNodeStatus.completed => 'Completed',
    WorkflowNodeStatus.failed => 'Failed',
    WorkflowNodeStatus.skipped => 'Skipped',
    WorkflowNodeStatus.unknown => 'Unknown',
  };
}
