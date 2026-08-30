import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_report_view.dart';

void main() {
  test('ReportScreen_WhenRenderedResultMissing_UsesNativeFallback', () {
    const run = WorkflowRun(
      runId: 'run-1',
      presetKey: 'smart-purchase-decision',
      status: WorkflowRunStatus.completed,
      nodes: [],
      report: ArzlyReport(
        schema: 'arzly.report',
        version: 2,
        kind: 'purchaseDecision',
        title: 'Decision',
        summary: 'Summary',
        generatedAtUtc: '2026-08-29T00:00:00Z',
        blocks: [],
        sources: [],
      ),
    );
    expect(shouldUseRenderedHtml(run), isFalse);
    expect(nativeReportForRun(run), isNotNull);
  });
}
