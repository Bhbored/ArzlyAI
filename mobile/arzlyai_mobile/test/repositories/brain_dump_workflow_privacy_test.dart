import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/approval_snapshot_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/rendered_workflow_result_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_node_run_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/workflow/brain_dump_preset_privacy.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

import '../helpers/fakes.dart';

const _dump = 'Call mom, finish quarterly report, buy groceries';
const _secret = 'therapy-notes-very-private';
const _html = '<html><body>$_dump $_secret</body></html>';

void main() {
  test(
    'PersistDto_WhenBrainDumpPreset_PersistsOnlyOperationalMetadata',
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

      final instance = await workflowRepository.createInstance(
        presetKey: brainDumpPresetKey,
        presetVersion: 1,
        name: 'Brain Dump to Action',
        topic: 'Brain dump plan',
        modelOverridesJson:
            '[{"agentKey":"plan-compiler","provider":"openai","model":"gpt-5-mini"}]',
      );
      await scheduleRepository.upsert(
        localWorkflowId: instance.id,
        localTime: '08:00',
        timeZoneId: 'UTC',
        enabled: true,
        workflowInputs: const {
          'brainDump': 'Configured dump text',
          'asOfDate': '2026-08-31',
          'workingHoursStart': '09:00',
          'workingHoursEnd': '17:00',
          'syncTasks': 'true',
        },
        presetName: 'Brain Dump to Action',
        nextRunAtUtc: DateTime.utc(2026, 9, 1, 8),
      );
      await scheduleRepository.recordFailure(
        localWorkflowId: instance.id,
        message: 'Failed while planning $_dump with $_secret',
      );

      final activeRun = await workflowRepository.persistDto(
        _brainDumpDto(),
        localWorkflowId: instance.id,
        expiryUtc: DateTime.utc(2026, 9, 1),
      );

      expect(activeRun.nodes.single.output, contains(_dump));
      expect(activeRun.approval?.currentContent, contains(_dump));
      expect(activeRun.renderedResult?.content, _html);

      final runRow = await (db.select(
        db.workflowRuns,
      )..where((row) => row.runId.equals(activeRun.runId))).getSingle();
      expect(runRow.approvalSnapshotJson, isNull);
      expect(runRow.finalResponse, isNull);
      expect(runRow.resultDocumentJson, isNull);
      expect(runRow.renderedResultContent, isNull);

      final nodeRow = await (db.select(
        db.workflowNodeRuns,
      )..where((row) => row.runId.equals(activeRun.runId))).getSingle();
      expect(nodeRow.output, isNull);
      expect(nodeRow.error, isNull);

      final persistedRun = await workflowRepository.getLocalRun(activeRun.runId);
      expect(persistedRun?.approval, isNull);
      expect(persistedRun?.report, isNull);
      expect(persistedRun?.renderedResult, isNull);

      final schedule = await scheduleRepository.getByWorkflowId(instance.id);
      expect(
        schedule?.failureMessage,
        'Brain dump workflow could not run in the background.',
      );

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
      expect(persistedText, isNot(contains(_dump)));
      expect(persistedText, isNot(contains(_secret)));
    },
  );
}

WorkflowRunResponse _brainDumpDto() {
  return WorkflowRunResponse(
    runId: 'run-brain-dump',
    presetKey: brainDumpPresetKey,
    status: 'Completed',
    nodes: const [
      WorkflowNodeRunResponse(
        nodeId: 'brain-dump-node',
        nodeKey: 'plan-compiler',
        displayName: 'Plan Compiler',
        type: 'Agent',
        status: 'Completed',
        isRunning: false,
        output: 'Plan for $_dump with $_secret',
        error: null,
        effectiveProvider: 'openai',
        effectiveModel: 'gpt-5-mini',
        effectiveTemperature: 0.3,
      ),
    ],
    approval: const ApprovalSnapshotResponse(
      originalContent: 'Draft $_dump $_secret',
      currentContent: 'Edited $_dump $_secret',
      wasEdited: true,
    ),
    finalResponse: '{"plan":"$_dump","secret":"$_secret"}',
    resultDocument: const {
      'schema': 'arzly.report',
      'version': 4,
      'kind': 'actionPlan',
      'title': 'Private action plan',
      'summary': '$_dump $_secret',
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
