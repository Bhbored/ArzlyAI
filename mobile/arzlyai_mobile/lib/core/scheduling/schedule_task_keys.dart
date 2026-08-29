abstract final class ScheduleTaskKeys {
  static String platformTaskId(String localWorkflowId) => 'workflow:$localWorkflowId';

  static const backgroundTaskName = 'scheduledWorkflow';
}
