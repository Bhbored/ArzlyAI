import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../../helpers/fakes.dart';

void main() {
  test('ReportPersistence_WhenAppRestarts_RestoresHtmlDocument', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = WorkflowRepository(
      db,
      FakeWorkflowService(),
      const WorkflowRunMapper(),
      const ArzlyReportMapper(),
    );
    const html = '<!doctype html><html><body>Report</body></html>';
    final run = WorkflowRun(
      runId: 'run-1',
      presetKey: 'smart-purchase-decision',
      status: WorkflowRunStatus.completed,
      nodes: const [],
      localWorkflowId: 'local-1',
      renderedResult: const RenderedWorkflowResult(
        mediaType: 'text/html',
        content: html,
      ),
    );
    await repo.persistRun(run);
    final restored = await repo.getLocalRun('run-1');
    expect(restored?.renderedResult?.mediaType, 'text/html');
    expect(restored?.renderedResult?.content, html);
  });
}
