import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/data/repositories/workflow_repository.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

void main() {
  test('workflow repository persists history without credentials', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = WorkflowRepository(
      db,
      WorkflowService(ApiExecutor(Dio())),
      const WorkflowRunMapper(),
    );

    final instance = await repo.createInstance(
      presetKey: 'daily-linkedin-ai-post',
      presetVersion: 1,
      name: 'Daily',
      topic: 'AI agents',
    );
    final run = WorkflowRun(
      runId: 'run-1',
      presetKey: 'daily-linkedin-ai-post',
      status: WorkflowRunStatus.waitingForApproval,
      nodes: const [
        WorkflowNodeRun(
          nodeId: 'n1',
          nodeKey: 'content-writer',
          displayName: 'Writer',
          type: 'Agent',
          status: WorkflowNodeStatus.completed,
          isRunning: false,
          output: 'draft post',
        ),
      ],
      approval: const ApprovalSnapshot(
        originalContent: 'draft post',
        currentContent: 'draft post',
        wasEdited: false,
      ),
      localWorkflowId: instance.id,
    );
    await repo.persistRun(run);

    final loaded = await repo.getLocalRun('run-1');
    expect(loaded, isNotNull);
    expect(loaded!.presetKey, 'daily-linkedin-ai-post');
    expect(loaded.nodes.single.output, 'draft post');

    final dump = await db.customSelect('SELECT * FROM workflow_runs').get();
    final encoded = dump.map((row) => row.data.toString()).join();
    expect(encoded.contains('sk-'), isFalse);
    expect(encoded.toLowerCase().contains('access_token'), isFalse);
    expect(encoded.contains('urn:li:person'), isFalse);
  });
}
