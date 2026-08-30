import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/approval_snapshot_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/rendered_workflow_result_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_node_run_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

import '../helpers/fakes.dart';

const _receiptRow = '2026-08-31,Secret Merchant,Medical,987.65';
const _secret = 'receipt-secret-card-4242';
const _html = '<html><body>$_receiptRow $_secret</body></html>';

void main() {
  test(
    'PersistDto_WhenReceiptPreset_PersistsOnlyOperationalMetadata',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final workflowRepository = WorkflowRepository(
        db,
        FakeWorkflowService(),
        const WorkflowRunMapper(),
        const ArzlyReportMapper(),
      );
      final scheduleRepository = ScheduleRepository(
        db,
        const ScheduleOccurrenceCalculator(),
      );

      for (final presetKey in receiptPresetKeys) {
        final instance = await workflowRepository.createInstance(
          presetKey: presetKey,
          presetVersion: 1,
          name: 'Receipt configuration',
          topic: 'Configured receipt report',
          modelOverridesJson:
              '[{"agentKey":"receipt-report-writer",'
              '"provider":"openai","model":"gpt-5-mini"}]',
        );
        await scheduleRepository.upsert(
          localWorkflowId: instance.id,
          localTime: '09:30',
          timeZoneId: 'UTC',
          enabled: true,
          workflowInputs: const {
            'spreadsheetId': 'configured-sheet-id',
            'sourceRange': "'Receipts'!A:Z",
            'currencyCode': 'USD',
          },
          presetName: 'Receipt configuration',
          nextRunAtUtc: DateTime.utc(2026, 9, 1, 9, 30),
        );
        await scheduleRepository.recordFailure(
          localWorkflowId: instance.id,
          message: 'Failed while processing $_receiptRow with $_secret',
        );

        final activeRun = await workflowRepository.persistDto(
          _receiptDto(presetKey),
          localWorkflowId: instance.id,
          expiryUtc: DateTime.utc(2026, 9, 1),
        );

        expect(activeRun.nodes.single.output, contains(_receiptRow));
        expect(activeRun.nodes.single.error, contains(_secret));
        expect(activeRun.approval?.currentContent, contains(_receiptRow));
        expect(activeRun.finalResponse, contains(_receiptRow));
        expect(activeRun.report?.summary, contains(_receiptRow));
        expect(activeRun.renderedResult?.content, _html);

        final runRow = await (db.select(
          db.workflowRuns,
        )..where((row) => row.runId.equals(activeRun.runId))).getSingle();
        expect(runRow.localWorkflowId, instance.id);
        expect(runRow.presetKey, presetKey);
        expect(runRow.status, 'Completed');
        expect(runRow.approvalSnapshotJson, isNull);
        expect(runRow.finalResponse, isNull);
        expect(runRow.resultDocumentJson, isNull);
        expect(runRow.resultContractKey, isNull);
        expect(runRow.resultContractVersion, isNull);
        expect(runRow.renderedResultMediaType, isNull);
        expect(runRow.renderedResultContent, isNull);
        expect(runRow.expiryUtc?.toUtc(), DateTime.utc(2026, 9, 1));

        final nodeRow = await (db.select(
          db.workflowNodeRuns,
        )..where((row) => row.runId.equals(activeRun.runId))).getSingle();
        expect(nodeRow.status, 'Completed');
        expect(nodeRow.output, isNull);
        expect(nodeRow.error, isNull);
        expect(nodeRow.effectiveProvider, 'openai');
        expect(nodeRow.effectiveModel, 'gpt-5-mini');
        expect(nodeRow.effectiveTemperature, 0.2);

        final persistedRun = await workflowRepository.getLocalRun(
          activeRun.runId,
        );
        expect(persistedRun?.status.name, 'completed');
        expect(persistedRun?.nodes.single.output, isNull);
        expect(persistedRun?.nodes.single.error, isNull);
        expect(persistedRun?.approval, isNull);
        expect(persistedRun?.finalResponse, isNull);
        expect(persistedRun?.report, isNull);
        expect(persistedRun?.renderedResult, isNull);

        final persistedInstance = await workflowRepository.getInstance(
          instance.id,
        );
        expect(persistedInstance?.topic, 'Configured receipt report');
        expect(persistedInstance?.modelOverridesJson, contains('gpt-5-mini'));
        final schedule = await scheduleRepository.getByWorkflowId(instance.id);
        final configuration = await scheduleRepository.getConfiguration(
          instance.id,
        );
        expect(schedule?.enabled, isTrue);
        expect(
          schedule?.failureMessage,
          'Receipt workflow could not run in the background.',
        );
        expect(schedule?.nextRunAtUtc.toUtc(), DateTime.utc(2026, 9, 1, 9, 30));
        expect(configuration?.inputs['spreadsheetId'], 'configured-sheet-id');
        expect(configuration?.inputs['sourceRange'], "'Receipts'!A:Z");
      }

      final privateRows = await db.customSelect('''
SELECT approval_snapshot_json, final_response, result_document_json,
       rendered_result_content
FROM workflow_runs
UNION ALL
SELECT output, error, NULL, NULL
FROM workflow_node_runs
''').get();
      final persistedText = privateRows
          .expand((row) => row.data.values)
          .whereType<String>()
          .join(' ');
      expect(persistedText, isNot(contains(_receiptRow)));
      expect(persistedText, isNot(contains(_secret)));
      expect(persistedText, isNot(contains('<html>')));
      final scheduleErrors = await db
          .customSelect('SELECT failure_message FROM schedules')
          .get();
      final persistedErrors = scheduleErrors
          .map((row) => row.readNullable<String>('failure_message'))
          .whereType<String>()
          .join(' ');
      expect(persistedErrors, isNot(contains(_receiptRow)));
      expect(persistedErrors, isNot(contains(_secret)));
    },
  );
}

WorkflowRunResponse _receiptDto(String presetKey) {
  return WorkflowRunResponse(
    runId: 'run-$presetKey',
    presetKey: presetKey,
    status: 'Completed',
    nodes: const [
      WorkflowNodeRunResponse(
        nodeId: 'receipt-node',
        nodeKey: 'receipt-report-writer',
        displayName: 'Receipt report writer',
        type: 'Agent',
        status: 'Completed',
        isRunning: false,
        output: 'Rows: $_receiptRow; token=$_secret',
        error: 'Rejected row $_receiptRow using $_secret',
        effectiveProvider: 'openai',
        effectiveModel: 'gpt-5-mini',
        effectiveTemperature: 0.2,
      ),
    ],
    approval: const ApprovalSnapshotResponse(
      originalContent: 'Draft $_receiptRow $_secret',
      currentContent: 'Edited $_receiptRow $_secret',
      wasEdited: true,
    ),
    finalResponse: '{"receipt":"$_receiptRow","secret":"$_secret"}',
    resultDocument: const {
      'schema': 'arzly.report',
      'version': 4,
      'kind': 'receiptAnalysis',
      'title': 'Private receipt report',
      'summary': '$_receiptRow $_secret',
      'generatedAtUtc': '2026-08-31T00:00:00Z',
      'blocks': [],
      'sources': [],
    },
    renderedResult: const RenderedWorkflowResultResponse(
      mediaType: 'text/html',
      content: _html,
    ),
  );
}
