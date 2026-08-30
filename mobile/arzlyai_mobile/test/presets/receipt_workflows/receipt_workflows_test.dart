import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/data/providers/temp/google_sheet_selection_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/execution_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/receipt_report_view.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/receipt_workflow_metadata.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/result_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_run_router.dart';

const _agent = Agent(
  key: receiptReportWriterAgentKey,
  name: 'Receipt Report Writer',
  systemPrompt: 'Write a receipt report.',
  isSystemPromptEditable: false,
  modelConfiguration: AgentModelConfiguration(
    provider: 'openai',
    selectedModel: 'gpt-5-mini',
    availableModels: [
      ModelOption(
        provider: 'openai',
        model: 'gpt-5-mini',
        displayName: 'GPT-5 Mini',
      ),
    ],
    isModelEditable: true,
    temperature: 0.2,
    minimumTemperature: 0,
    maximumTemperature: 1,
    isTemperatureEditable: true,
    supportsWebSearch: false,
  ),
  harness: AgentHarness(
    planningEnabled: false,
    todoTrackingEnabled: false,
    contextCompactionEnabled: true,
    requiresToolApproval: false,
    maximumIterations: 3,
    webSearchEnabled: false,
  ),
);

PresetDetails _details(String key) {
  return PresetDetails(
    id: key,
    key: key,
    name: receiptMetadataForKey(key)!.title,
    description: receiptMetadataForKey(key)!.description,
    version: 1,
    agents: const [_agent],
    workflow: const WorkflowGraph(
      key: 'analyze-and-deliver',
      nodes: [
        WorkflowNode(
          id: 'read',
          key: 'google.sheets.read',
          displayName: 'Read receipt sheet',
          type: 'Integration',
          position: 1,
          requiresHumanApproval: false,
        ),
        WorkflowNode(
          id: 'writer',
          key: receiptReportWriterAgentKey,
          displayName: 'Receipt Report Writer',
          type: 'Agent',
          position: 2,
          requiresHumanApproval: false,
        ),
        WorkflowNode(
          id: 'email',
          key: 'google.gmail.send-html',
          displayName: 'Email receipt report',
          type: 'Integration',
          position: 3,
          requiresHumanApproval: false,
        ),
      ],
      connections: [],
    ),
    integrations: const [
      IntegrationRequirement(
        key: 'google.sheets.read',
        name: 'Google Sheets Read',
        description: 'Read a sheet.',
        credentialSchemaJson:
            '{"type":"oauth2AccessToken","fields":["google.accessToken","google.email"]}',
      ),
      IntegrationRequirement(
        key: 'google.gmail.send-html',
        name: 'Gmail HTML',
        description: 'Send a report.',
        credentialSchemaJson:
            '{"type":"oauth2AccessToken","fields":["google.accessToken","google.email"]}',
      ),
    ],
    resultContract: const ResultContract(key: 'arzly.report', version: 4),
  );
}

void main() {
  test('ReceiptMetadata_WhenFixtureLoaded_CoversAllSevenBackendKeys', () {
    final fixture =
        jsonDecode(
              File(
                'test/presets/receipt_workflows/fixtures/receipt_presets.json',
              ).readAsStringSync(),
            )
            as List<dynamic>;

    expect(receiptWorkflowMetadata, hasLength(7));
    expect(
      receiptPresetKeys,
      fixture.map((item) => (item as Map<String, dynamic>)['key']).toSet(),
    );
    for (final item in fixture.cast<Map<String, dynamic>>()) {
      final metadata = receiptMetadataForKey(item['key'] as String);
      expect(metadata, isNotNull);
      expect(metadata!.mode, item['mode']);
      expect(metadata.requiresBudget, item['requiresBudget']);
      expect(metadata.requiresTaxRate, item['requiresTaxRate']);
      expect(metadata.requiresCategory, item['requiresCategory']);
    }
  });

  test('ReceiptRouting_WhenAnyReceiptKeyUsed_ReturnsSharedScreens', () {
    for (final key in receiptPresetKeys) {
      expect(
        configureRunScreenForPreset(key),
        isA<ReceiptConfigureRunScreen>(),
      );
      expect(executionScreenForPreset(key), isA<ReceiptExecutionScreen>());
      expect(resultScreenForPreset(key), isA<ReceiptResultScreen>());
    }
  });

  test('ReceiptConfig_WhenPrepared_MapsHeadersAndForcesPreviewDelivery', () {
    final metadata = receiptMetadataForKey('receipt-weekly-budget')!;
    final result = prepareReceiptRunConfig(
      config: const RunConfigState(
        inputs: {
          'range': 'A:D',
          'asOfDate': '2026-08-30',
          'currencyCode': 'usd',
          'budget': '200',
          'includeCharts': 'true',
          'recipientEmail': 'user@example.com',
          'deliveryMode': 'both',
        },
      ),
      selection: const GoogleSheetSelectionState(
        spreadsheetId: 'sheet-1',
        tabTitle: "August Receipts",
        headerMapping: {
          'date': 'Date',
          'merchant': 'Vendor',
          'category': 'Category',
          'amount': 'Amount',
        },
      ),
      metadata: metadata,
      details: _details(metadata.key),
    );

    expect(result.error, isNull);
    expect(result.config!.inputs['spreadsheetId'], 'sheet-1');
    expect(result.config!.inputs['sourceRange'], "'August Receipts'!A:D");
    expect(result.config!.inputs['deliveryMode'], 'preview');
    expect(result.config!.inputs['currencyCode'], 'USD');
    expect(jsonDecode(result.config!.inputs['columnMappingJson']!), {
      'date': 'Date',
      'amount': 'Amount',
      'category': 'Category',
      'merchant': 'Vendor',
    });
  });

  test(
    'ReceiptConfig_WhenProviderOverrideSelected_PreservesProviderAndModel',
    () {
      final metadata = receiptMetadataForKey('receipt-monthly-spending')!;
      final result = prepareReceiptRunConfig(
        config: const RunConfigState(
          inputs: {
            'range': 'A:D',
            'asOfDate': '2026-08-30',
            'currencyCode': 'USD',
          },
          agentOverrides: {
            receiptReportWriterAgentKey: AgentOverrideDraft(
              provider: 'gemini',
              model: 'gemini-2.5-flash',
            ),
          },
        ),
        selection: const GoogleSheetSelectionState(
          spreadsheetId: 'sheet-1',
          tabTitle: 'Receipts',
          headerMapping: {
            'date': 'Date',
            'merchant': 'Merchant',
            'category': 'Category',
            'amount': 'Amount',
          },
        ),
        metadata: metadata,
        details: _details(metadata.key),
      );

      final override =
          result.config!.agentOverrides[receiptReportWriterAgentKey]!;
      expect(override.provider, 'gemini');
      expect(override.model, 'gemini-2.5-flash');
    },
  );

  test('ReceiptCredentials_WhenGraphStartsWithGoogle_IncludesGoogleFields', () {
    final keys = _details(
      'receipt-monthly-spending',
    ).workflowStartCredentialKeys(overrideProviders: const ['anthropic']);

    expect(keys, contains(providerCredentialEnvelopeKey('anthropic')));
    expect(
      keys,
      contains(
        integrationFieldEnvelopeKey('google.sheets.read', 'google.accessToken'),
      ),
    );
    expect(
      keys,
      contains(
        integrationFieldEnvelopeKey('google.sheets.read', 'google.email'),
      ),
    );
  });

  test('ReceiptReport_WhenBackendHtmlPresent_UsesRenderedHtml', () {
    final html = File(
      'test/presets/receipt_workflows/fixtures/receipt_report.html',
    ).readAsStringSync();
    final run = WorkflowRun(
      runId: 'receipt-run',
      presetKey: 'receipt-monthly-spending',
      status: WorkflowRunStatus.completed,
      nodes: const [],
      renderedResult: RenderedWorkflowResult(
        mediaType: 'text/html',
        content: html,
      ),
    );

    expect(hasReceiptReportHtml(run), isTrue);
    expect(ReceiptReportView(run: run).run.renderedResult!.content, html);
  });
}
