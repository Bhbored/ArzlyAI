import 'package:workmanager/workmanager.dart';
import 'package:arzlyai_mobile/core/background/workflow_scheduling_composition.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_task_keys.dart';

@pragma('vm:entry-point')
void workflowBackgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != ScheduleTaskKeys.backgroundTaskName) {
      return false;
    }
    final composition = await WorkflowSchedulingComposition.create();
    try {
      final localWorkflowId = inputData?['localWorkflowId'] as String?;
      if (localWorkflowId == null || localWorkflowId.isEmpty) {
        return true;
      }
      await composition.executor.execute(localWorkflowId);
      return true;
    } finally {
      await composition.close();
    }
  });
}
