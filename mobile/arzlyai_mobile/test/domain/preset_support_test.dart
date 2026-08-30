import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';

PresetDetails smartPurchaseDetails() {
  return const PresetMapper().detailsFromDto(
    PresetDetailsResponse.fromJson(
      jsonDecode(
            File(
              'test/presets/smart_purchase_decision/fixtures/preset_details.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>,
    ),
  );
}

PresetDetails linkedInDetails() {
  return const PresetMapper().detailsFromDto(
    PresetDetailsResponse.fromJson(
      jsonDecode(
            File(
              'test/presets/daily_linkedin_ai_post/fixtures/preset_details.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>,
    ),
  );
}

void main() {
  test('approvalCredentialKeys accept at confirm inherits completed agent provider', () {
    final details = smartPurchaseDetails();
    final run = WorkflowRun(
      runId: 'run-1',
      presetKey: details.key,
      status: WorkflowRunStatus.waitingForApproval,
      nodes: [
        const WorkflowNodeRun(
          nodeId: '1',
          nodeKey: 'understand-request',
          displayName: 'Understand request',
          type: 'Agent',
          status: WorkflowNodeStatus.completed,
          isRunning: false,
          effectiveProvider: 'deepseek',
        ),
        const WorkflowNodeRun(
          nodeId: '2',
          nodeKey: 'confirm-request',
          displayName: 'Confirm',
          type: 'HumanApproval',
          status: WorkflowNodeStatus.waitingForApproval,
          isRunning: false,
        ),
        const WorkflowNodeRun(
          nodeId: '3',
          nodeKey: 'shop-and-recommend',
          displayName: 'Search and compare',
          type: 'Agent',
          status: WorkflowNodeStatus.idle,
          isRunning: false,
        ),
      ],
    );

    final keys = details.approvalCredentialKeys(
      run: run,
      decision: ApprovalDecision.accept,
    );

    expect(keys, [providerCredentialEnvelopeKey('deepseek')]);
  });

  test('approvalCredentialKeys accept at confirm uses next agent override provider', () {
    final details = smartPurchaseDetails();
    final run = WorkflowRun(
      runId: 'run-1',
      presetKey: details.key,
      status: WorkflowRunStatus.waitingForApproval,
      nodes: [
        const WorkflowNodeRun(
          nodeId: '1',
          nodeKey: 'understand-request',
          displayName: 'Understand request',
          type: 'Agent',
          status: WorkflowNodeStatus.completed,
          isRunning: false,
          effectiveProvider: 'deepseek',
        ),
        const WorkflowNodeRun(
          nodeId: '2',
          nodeKey: 'confirm-request',
          displayName: 'Confirm',
          type: 'HumanApproval',
          status: WorkflowNodeStatus.waitingForApproval,
          isRunning: false,
        ),
        const WorkflowNodeRun(
          nodeId: '3',
          nodeKey: 'shop-and-recommend',
          displayName: 'Search and compare',
          type: 'Agent',
          status: WorkflowNodeStatus.idle,
          isRunning: false,
        ),
      ],
    );

    final keys = details.approvalCredentialKeys(
      run: run,
      decision: ApprovalDecision.accept,
      overrideProvidersByAgent: const {
        'shop-and-recommend': 'deepseek',
        'understand-request': 'deepseek',
      },
    );

    expect(keys, [providerCredentialEnvelopeKey('deepseek')]);
  });

  test('approvalCredentialKeys edit at confirm uses prior agent override provider', () {
    final details = smartPurchaseDetails();
    final run = WorkflowRun(
      runId: 'run-1',
      presetKey: details.key,
      status: WorkflowRunStatus.waitingForApproval,
      nodes: [
        const WorkflowNodeRun(
          nodeId: '1',
          nodeKey: 'understand-request',
          displayName: 'Understand request',
          type: 'Agent',
          status: WorkflowNodeStatus.completed,
          isRunning: false,
        ),
        const WorkflowNodeRun(
          nodeId: '2',
          nodeKey: 'confirm-request',
          displayName: 'Confirm',
          type: 'HumanApproval',
          status: WorkflowNodeStatus.waitingForApproval,
          isRunning: false,
        ),
        const WorkflowNodeRun(
          nodeId: '3',
          nodeKey: 'shop-and-recommend',
          displayName: 'Search and compare',
          type: 'Agent',
          status: WorkflowNodeStatus.idle,
          isRunning: false,
        ),
      ],
    );

    final keys = details.approvalCredentialKeys(
      run: run,
      decision: ApprovalDecision.edit,
      overrideProvidersByAgent: const {'understand-request': 'deepseek'},
    );

    expect(keys, [providerCredentialEnvelopeKey('deepseek')]);
  });

  test('LinkedIn start credentials use selected provider', () {
    final keys = linkedInDetails().workflowStartCredentialKeys(
      overrideProviders: const ['gemini'],
    );

    expect(keys, [providerCredentialEnvelopeKey('gemini')]);
  });

  test('LinkedIn edit uses writer provider and accept uses connector credentials', () {
    final details = linkedInDetails();
    const run = WorkflowRun(
      runId: 'linkedin-run',
      presetKey: 'daily-linkedin-ai-post',
      status: WorkflowRunStatus.waitingForApproval,
      nodes: [
        WorkflowNodeRun(
          nodeId: '1',
          nodeKey: 'content-writer',
          displayName: 'Writer',
          type: 'Agent',
          status: WorkflowNodeStatus.completed,
          isRunning: false,
          effectiveProvider: 'anthropic',
        ),
        WorkflowNodeRun(
          nodeId: '2',
          nodeKey: 'review-post',
          displayName: 'Review',
          type: 'HumanApproval',
          status: WorkflowNodeStatus.waitingForApproval,
          isRunning: false,
        ),
        WorkflowNodeRun(
          nodeId: '3',
          nodeKey: 'linkedin-publisher',
          displayName: 'Publisher',
          type: 'Agent',
          status: WorkflowNodeStatus.idle,
          isRunning: false,
        ),
        WorkflowNodeRun(
          nodeId: '4',
          nodeKey: 'linkedin.posts',
          displayName: 'Publish',
          type: 'Integration',
          status: WorkflowNodeStatus.idle,
          isRunning: false,
        ),
      ],
    );

    expect(
      details.approvalCredentialKeys(
        run: run,
        decision: ApprovalDecision.edit,
      ),
      [providerCredentialEnvelopeKey('anthropic')],
    );
    expect(
      details.approvalCredentialKeys(
        run: run,
        decision: ApprovalDecision.accept,
      ),
      containsAll([
        integrationFieldEnvelopeKey('linkedin.posts', 'accessToken'),
        integrationFieldEnvelopeKey('linkedin.posts', 'authorUrn'),
      ]),
    );
  });
}
