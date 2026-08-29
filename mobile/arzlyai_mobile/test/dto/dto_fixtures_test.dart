import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/submit_approval_request.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/connector_session_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/connector_status_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/models/openai_model_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_summary_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/network/dto/security/encryption_key_descriptor.dart';

Map<String, dynamic> _linkedinFixture(String name) {
  return jsonDecode(
        File(
          'test/presets/daily_linkedin_ai_post/fixtures/$name',
        ).readAsStringSync(),
      )
      as Map<String, dynamic>;
}

Map<String, dynamic> _networkFixture(String name) {
  return jsonDecode(File('test/fixtures/network/$name').readAsStringSync())
      as Map<String, dynamic>;
}

void main() {
  test('preset summary fixture parses', () {
    final summary = PresetSummaryResponse.fromJson(
      _linkedinFixture('preset_summary.json'),
    );
    expect(summary.key, 'daily-linkedin-ai-post');
    expect(summary.version, 1);
  });

  test('preset details fixture parses graph and flags', () {
    final details = PresetDetailsResponse.fromJson(
      _linkedinFixture('preset_details.json'),
    );
    expect(details.agents.length, 2);
    expect(details.agents.first.isSystemPromptEditable, isFalse);
    expect(details.agents.first.modelConfiguration.isModelEditable, isTrue);
    expect(details.workflow.nodes.map((n) => n.position).toList(), [
      1,
      2,
      3,
      4,
    ]);
    expect(
      details.workflow.connections.first.sourceNodeId,
      details.workflow.nodes.first.id,
    );
  });

  test('waiting run fixture parses approval snapshot', () {
    final run = WorkflowRunResponse.fromJson(
      _linkedinFixture('workflow_run_waiting.json'),
    );
    expect(run.status, 'WaitingForApproval');
    expect(run.approval?.wasEdited, isFalse);
    expect(run.finalResponse, isNull);
  });

  test('completed run fixture includes linkedin identifier', () {
    final run = WorkflowRunResponse.fromJson(
      _linkedinFixture('workflow_run_completed.json'),
    );
    expect(run.status, 'Completed');
    expect(run.finalResponse, 'urn:li:share:123');
    expect(run.approval?.wasEdited, isTrue);
  });

  test('approval decisions serialize numerically', () {
    const envelope = CredentialEnvelope(
      keyId: 'k',
      requestId: 'r',
      expiresAtUnixSeconds: 1,
      wrappedKey: 'w',
      nonce: 'n',
      ciphertext: 'c',
      tag: 't',
    );
    expect(
      const SubmitApprovalRequest(
        decision: ApprovalDecision.accept,
        credentials: envelope,
      ).toJson()['decision'],
      0,
    );
    expect(
      const SubmitApprovalRequest(
        decision: ApprovalDecision.edit,
        editedContent: 'edited',
        credentials: envelope,
      ).toJson()['decision'],
      1,
    );
    expect(
      const SubmitApprovalRequest(
        decision: ApprovalDecision.reject,
      ).toJson()['decision'],
      2,
    );
    expect(
      SubmitApprovalRequest.fromJson({
        'decision': 1,
        'editedContent': 'x',
      }).decision,
      ApprovalDecision.edit,
    );
  });

  test('encryption key descriptor fixture parses', () {
    final descriptor = EncryptionKeyDescriptor.fromJson(
      _networkFixture('encryption_key.json'),
    );
    expect(descriptor.keyId, 'key-1');
    expect(descriptor.maximumLifetimeSeconds, 120);
    expect(descriptor.algorithm, contains('OAEP'));
  });

  test('connector session and status fixtures parse', () {
    final session = ConnectorSessionResponse.fromJson(
      _networkFixture('connector_session.json'),
    );
    expect(session.connectUrl, contains('nango.dev'));
    expect(session.sessionToken, isNotEmpty);

    final status = ConnectorStatusResponse.fromJson(
      _networkFixture('connector_status.json'),
    );
    expect(status.connectorKey, 'linkedin');
    expect(status.isConnected, isTrue);
  });

  test('openai model fixture parses supportsTemperature true and false', () {
    final list =
        jsonDecode(
              File(
                'test/fixtures/network/openai_models.json',
              ).readAsStringSync(),
            )
            as List<dynamic>;
    final models = list
        .map(
          (item) => OpenAiModelResponse.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
    expect(models.first.supportsTemperature, isFalse);
    expect(models.last.supportsTemperature, isTrue);
    expect(models.first.id, 'gpt-5-mini');
    expect(models.last.displayName, 'GPT 4.1 Mini');
  });
}
