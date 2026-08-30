import 'package:drift/native.dart';import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_transport_state.dart';
import 'package:arzlyai_mobile/core/workflow/workflow_reconciliation.dart';
import 'package:arzlyai_mobile/data/providers/workflow/workflow_transport_provider.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../helpers/fakes.dart';

void main() {
  test('RunRepository_WhenTransportTimeout_ReconcilesByRunId', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final workflows = FakeWorkflowService(
      getResult: completedRunDto(),
    );
    final repo = WorkflowRepository(
      db,
      workflows,
      const WorkflowRunMapper(),
      const ArzlyReportMapper(),
    );
    final instance = await repo.createInstance(
      presetKey: 'daily-linkedin-ai-post',
      presetVersion: 1,
      name: 'Daily',
      topic: 'AI agents',
    );
    await repo.persistDto(
      waitingRunDto(),
      localWorkflowId: instance.id,
    );
    final run = await repo.reconcileByRunId(
      waitingRunDto().runId,
      localWorkflowId: instance.id,
      wait: (_) async {},
    );
    expect(run, isNotNull);
    expect(run!.status, WorkflowRunStatus.completed);
    expect(workflows.getResult.status, 'Completed');
  });

  test('ApprovalView_WhenSnapshotStillPending_AllowsRetryOnce', () {
    const locked = WorkflowTransportStatus(
      transport: WorkflowTransportState.processing,
      lockedApprovalNodeId: 'approval-1',
    );
    expect(locked.blocksApproval, isTrue);

    const cleared = WorkflowTransportStatus(
      transport: WorkflowTransportState.idle,
    );
    expect(cleared.blocksApproval, isFalse);
  });

  test('isReconcileTerminal covers waiting and terminal statuses', () {
    expect(isReconcileTerminal(WorkflowRunStatus.waitingForApproval), isTrue);
    expect(isReconcileTerminal(WorkflowRunStatus.completed), isTrue);
    expect(isReconcileTerminal(WorkflowRunStatus.running), isFalse);
  });
}
