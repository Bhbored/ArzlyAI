enum WorkflowRunStatus {
  running,
  waitingForApproval,
  completed,
  failed,
  cancelled,
  expired,
  unknown,
}

extension WorkflowRunStatusX on WorkflowRunStatus {
  static WorkflowRunStatus parse(String? value) {
    return switch (value) {
      'Running' => WorkflowRunStatus.running,
      'WaitingForApproval' => WorkflowRunStatus.waitingForApproval,
      'Completed' => WorkflowRunStatus.completed,
      'Failed' => WorkflowRunStatus.failed,
      'Cancelled' => WorkflowRunStatus.cancelled,
      'Expired' => WorkflowRunStatus.expired,
      _ => WorkflowRunStatus.unknown,
    };
  }

  String get wireValue => switch (this) {
    WorkflowRunStatus.running => 'Running',
    WorkflowRunStatus.waitingForApproval => 'WaitingForApproval',
    WorkflowRunStatus.completed => 'Completed',
    WorkflowRunStatus.failed => 'Failed',
    WorkflowRunStatus.cancelled => 'Cancelled',
    WorkflowRunStatus.expired => 'Expired',
    WorkflowRunStatus.unknown => 'Unknown',
  };
}
