import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';

void main() {
  test('merge prefers newer occurredAtUtc', () {
    const mapper = WorkflowRunMapper();
    final run = WorkflowRun(
      runId: 'r1',
      presetKey: 'daily-linkedin-ai-post',
      status: WorkflowRunStatus.running,
      nodes: const [
        WorkflowNodeRun(
          nodeId: 'n1',
          nodeKey: 'content-writer',
          displayName: 'Writer',
          type: 'Agent',
          status: WorkflowNodeStatus.running,
          isRunning: true,
        ),
      ],
    );
    final older = WorkflowNodeChanged(
      runId: 'r1',
      nodeId: 'n1',
      nodeKey: 'content-writer',
      status: WorkflowNodeStatus.idle,
      isRunning: false,
      message: 'old',
      occurredAtUtc: DateTime.utc(2026, 1, 1),
    );
    final newer = older.copyWith(
      status: WorkflowNodeStatus.completed,
      occurredAtUtc: DateTime.utc(2026, 1, 2),
    );
    final merged = mapper.mergeEvent(mapper.mergeEvent(run, newer), older);
    expect(merged.nodes.single.status, WorkflowNodeStatus.completed);
  });
}
