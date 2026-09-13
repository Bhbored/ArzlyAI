import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/brain_dump_run_config.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_run_router.dart';

PresetDetails brainDumpDetails() {
  return const PresetMapper().detailsFromDto(
    PresetDetailsResponse.fromJson(
      jsonDecode(
            File(
              'test/presets/brain_dump_to_action/fixtures/preset_details.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>,
    ),
  );
}

void main() {
  test('configureRunScreenForPreset routes brain dump preset', () {
    expect(configureRunScreenForPreset(BrainDumpToActionPreset.key), isNotNull);
    expect(executionScreenForPreset(BrainDumpToActionPreset.key), isNotNull);
  });

  test('prepareBrainDumpRunConfig preview forces sync flags false', () {
    final details = brainDumpDetails();
    const config = RunConfigState(
      topic: 'Brain dump plan',
      inputs: {
        'brainDump': 'Finish taxes and call dentist',
        'asOfDate': '2026-08-31',
        'workingHoursStart': '09:00',
        'workingHoursEnd': '17:00',
        'syncTasks': 'true',
        'syncCalendar': 'true',
        'sendEmail': 'true',
        'recipientEmail': 'me@example.com',
      },
    );

    final prepared = prepareBrainDumpRunConfig(
      config: config,
      details: details,
      previewOnly: true,
    );

    expect(prepared.error, isNull);
    expect(prepared.config!.inputs['syncTasks'], 'false');
    expect(prepared.config!.inputs['syncCalendar'], 'false');
    expect(prepared.config!.inputs['sendEmail'], 'false');
  });

  test('buildScheduledBrainDumpInputs keeps sync flags', () {
    const config = RunConfigState(
      topic: 'Brain dump plan',
      inputs: {
        'brainDump': 'Ship feature and buy groceries',
        'asOfDate': '2026-08-31',
        'workingHoursStart': '09:00',
        'workingHoursEnd': '17:00',
        'syncTasks': 'true',
        'syncCalendar': 'false',
        'sendEmail': 'true',
        'recipientEmail': 'me@example.com',
      },
    );

    final inputs = buildScheduledBrainDumpInputs(
      config,
      details: brainDumpDetails(),
    );

    expect(inputs['syncTasks'], 'true');
    expect(inputs['syncCalendar'], 'false');
    expect(inputs['sendEmail'], 'true');
    expect(inputs['recipientEmail'], 'me@example.com');
    expect(inputs['brainDump'], contains('Ship feature'));
  });

  test('approvalCredentialKeys accept preview needs no google credentials', () {
    final details = brainDumpDetails();
    final run = WorkflowRun(
      runId: 'brain-dump-run',
      presetKey: details.key,
      status: WorkflowRunStatus.waitingForApproval,
      nodes: [
        const WorkflowNodeRun(
          nodeId: '1',
          nodeKey: 'plan-compiler',
          displayName: 'Plan Compiler',
          type: 'Agent',
          status: WorkflowNodeStatus.completed,
          isRunning: false,
        ),
        const WorkflowNodeRun(
          nodeId: '2',
          nodeKey: 'review-plan',
          displayName: 'Review plan',
          type: 'HumanApproval',
          status: WorkflowNodeStatus.waitingForApproval,
          isRunning: false,
        ),
        const WorkflowNodeRun(
          nodeId: '3',
          nodeKey: 'google.tasks.create',
          displayName: 'Sync Google Tasks',
          type: 'Integration',
          status: WorkflowNodeStatus.idle,
          isRunning: false,
        ),
      ],
    );

    expect(
      details.approvalCredentialKeys(
        run: run,
        decision: ApprovalDecision.accept,
        workflowInputs: const {
          'syncTasks': 'false',
          'syncCalendar': 'false',
          'sendEmail': 'false',
        },
      ),
      isEmpty,
    );
  });

  test(
    'approvalCredentialKeys accept with sync requests google credentials',
    () {
      final details = brainDumpDetails();
      final run = WorkflowRun(
        runId: 'brain-dump-run',
        presetKey: details.key,
        status: WorkflowRunStatus.waitingForApproval,
        nodes: [
          const WorkflowNodeRun(
            nodeId: '1',
            nodeKey: 'plan-compiler',
            displayName: 'Plan Compiler',
            type: 'Agent',
            status: WorkflowNodeStatus.completed,
            isRunning: false,
          ),
          const WorkflowNodeRun(
            nodeId: '2',
            nodeKey: 'review-plan',
            displayName: 'Review plan',
            type: 'HumanApproval',
            status: WorkflowNodeStatus.waitingForApproval,
            isRunning: false,
          ),
          const WorkflowNodeRun(
            nodeId: '3',
            nodeKey: 'google.tasks.create',
            displayName: 'Sync Google Tasks',
            type: 'Integration',
            status: WorkflowNodeStatus.idle,
            isRunning: false,
          ),
        ],
      );

      final keys = details.approvalCredentialKeys(
        run: run,
        decision: ApprovalDecision.accept,
        workflowInputs: const {
          'syncTasks': 'true',
          'syncCalendar': 'false',
          'sendEmail': 'false',
        },
      );

      expect(
        keys,
        contains(
          integrationFieldEnvelopeKey(
            'google.tasks.create',
            'google.accessToken',
          ),
        ),
      );
      expect(keys, isNot(contains('google.email')));
      expect(
        details.approvalIntegrationKeys(
          run: run,
          decision: ApprovalDecision.accept,
          workflowInputs: const {
            'syncTasks': 'true',
            'syncCalendar': 'false',
            'sendEmail': 'false',
          },
        ),
        ['google.tasks.create'],
      );
    },
  );
}
