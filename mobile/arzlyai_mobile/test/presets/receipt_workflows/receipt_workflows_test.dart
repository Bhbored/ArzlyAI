import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart';
import 'package:arzlyai_mobile/core/workflow/receipt_workflow_migration.dart';
import 'package:arzlyai_mobile/data/providers/temp/google_sheet_selection_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/input_schema_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
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

PresetInputSchema _schema() {
  final json = File(
    'test/presets/receipt_workflows/fixtures/receipt_intelligence_schema_v2.json',
  ).readAsStringSync();
  return const InputSchemaMapper().fromJsonString(json)!;
}

PresetDetails receiptTestDetails() {
  return PresetDetails(
    id: ReceiptIntelligencePreset.key,
    key: ReceiptIntelligencePreset.key,
    name: 'Receipt Intelligence',
    description: 'Unified receipt analysis preset.',
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
    inputSchema: null,
    resultContract: const ResultContract(key: 'arzly.report', version: 4),
  ).copyWith(inputSchema: _schema());
}

GoogleSheetSelectionState _selection() {
  return const GoogleSheetSelectionState(
    spreadsheetId: 'sheet-1',
    tabTitle: "August Receipts",
    headerMapping: {
      'date': 'Date',
      'merchant': 'Vendor',
      'category': 'Category',
      'amount': 'Amount',
    },
  );
}

void main() {
  test('ReceiptSchema_WhenFixtureLoaded_ExposesSevenAnalysisModes', () {
    final fixture =
        jsonDecode(
              File(
                'test/presets/receipt_workflows/fixtures/receipt_analysis_modes.json',
              ).readAsStringSync(),
            )
            as List<dynamic>;
    final schema = _schema();

    expect(schema.analysisModeOptions, hasLength(7));
    for (final item in fixture.cast<Map<String, dynamic>>()) {
      final option = schema.analysisModeOption(item['value'] as String);
      expect(option, isNotNull);
      expect(
        option!.requiresFields.contains('budget'),
        item['requiresBudget'],
      );
      expect(
        option.requiresFields.contains('taxRate'),
        item['requiresTaxRate'],
      );
      expect(
        option.requiresFields.contains('category'),
        item['requiresCategory'],
      );
    }
  });

  test('ReceiptRouting_WhenCanonicalOrLegacyKeyUsed_ReturnsSharedScreens', () {
    for (final key in receiptPresetKeys) {
      expect(
        configureRunScreenForPreset(key),
        isA<ReceiptConfigureRunScreen>(),
      );
      expect(executionScreenForPreset(key), isA<ReceiptExecutionScreen>());
      expect(resultScreenForPreset(key), isA<ReceiptResultScreen>());
    }
  });

  test('ReceiptConfig_WhenEachAnalysisModePrepared_ValidatesRequiredFields', () {
    final schema = _schema();
    final modes = schema.analysisModeOptions;
    expect(modes, hasLength(7));

    for (final option in modes) {
      final inputs = <String, String>{
        'analysisMode': option.value,
        'range': 'A:D',
        'asOfDate': '2026-08-30',
        'currencyCode': 'USD',
        'deliveryMode': 'preview',
      };
      if (option.requiresFields.contains('budget')) {
        inputs['budget'] = '100';
      }
      if (option.requiresFields.contains('taxRate')) {
        inputs['taxRate'] = '0.2';
      }
      if (option.requiresFields.contains('category')) {
        inputs['category'] = 'Food';
      }

      final result = prepareReceiptRunConfig(
        config: RunConfigState(inputs: inputs),
        selection: _selection(),
        schema: schema,
        details: receiptTestDetails(),
      );

      expect(result.error, isNull, reason: option.value);
      expect(result.config!.inputs['analysisMode'], option.value);
    }
  });

  test('ReceiptConfig_WhenWeeklyBudgetPrepared_IncludesAnalysisModeAndDelivery',
      () {
    final schema = _schema();
    final result = prepareReceiptRunConfig(
      config: const RunConfigState(
        inputs: {
          'analysisMode': 'weekly-budget',
          'range': 'A:D',
          'asOfDate': '2026-08-30',
          'currencyCode': 'usd',
          'budget': '200',
          'deliveryMode': 'both',
          'reportTabTitle': 'Weekly Report',
          'recipientEmail': 'user@example.com',
        },
      ),
      selection: _selection(),
      schema: schema,
      details: receiptTestDetails(),
    );

    expect(result.error, isNull);
    expect(result.config!.inputs['analysisMode'], 'weekly-budget');
    expect(result.config!.inputs['spreadsheetId'], 'sheet-1');
    expect(result.config!.inputs['sourceRange'], "'August Receipts'!A:D");
    expect(result.config!.inputs['deliveryMode'], 'both');
    expect(result.config!.inputs['recipientEmail'], 'user@example.com');
    expect(result.config!.inputs['currencyCode'], 'USD');
    expect(result.config!.inputs.containsKey('taxRate'), isFalse);
    expect(jsonDecode(result.config!.inputs['columnMappingJson']!), {
      'date': 'Date',
      'amount': 'Amount',
      'category': 'Category',
      'merchant': 'Vendor',
    });
  });

  test('ReceiptConfig_WhenMonthlyModePrepared_StripsInactiveConditionalFields', () {
    final result = prepareReceiptRunConfig(
      config: const RunConfigState(
        inputs: {
          'analysisMode': 'monthly-spending',
          'range': 'A:D',
          'asOfDate': '2026-08-30',
          'currencyCode': 'USD',
          'budget': '200',
          'taxRate': '0.2',
          'category': 'Food',
          'deliveryMode': 'preview',
        },
      ),
      selection: _selection(),
      schema: _schema(),
      details: receiptTestDetails(),
    );

    expect(result.error, isNull);
    expect(result.config!.inputs.containsKey('budget'), isFalse);
    expect(result.config!.inputs.containsKey('taxRate'), isFalse);
    expect(result.config!.inputs.containsKey('category'), isFalse);
  });

  test(
    'ReceiptConfig_WhenProviderOverrideSelected_PreservesProviderAndModel',
    () {
      final result = prepareReceiptRunConfig(
        config: const RunConfigState(
          inputs: {
            'analysisMode': 'monthly-spending',
            'range': 'A:D',
            'asOfDate': '2026-08-30',
            'currencyCode': 'USD',
            'deliveryMode': 'preview',
          },
          agentOverrides: {
            receiptReportWriterAgentKey: AgentOverrideDraft(
              provider: 'gemini',
              model: 'gemini-2.5-flash',
            ),
          },
        ),
        selection: _selection(),
        schema: _schema(),
        details: receiptTestDetails(),
      );

      final override =
          result.config!.agentOverrides[receiptReportWriterAgentKey]!;
      expect(override.provider, 'gemini');
      expect(override.model, 'gemini-2.5-flash');
    },
  );

  test('ReceiptCredentials_WhenGraphStartsWithGoogle_IncludesGoogleFields', () {
    final keys = receiptTestDetails().workflowStartCredentialKeys(
      overrideProviders: const ['anthropic'],
    );

    expect(keys, contains(providerCredentialEnvelopeKey('anthropic')));
    expect(
      keys,
      contains(
        integrationFieldEnvelopeKey('google.sheets.read', 'google.accessToken'),
      ),
    );
  });

  test('ReceiptResolve_WhenLegacyKeyProvided_MapsToCanonicalPresetAndMode', () {
    final resolved = resolveReceiptWorkflowStart(
      presetKey: 'receipt-weekly-budget',
      inputs: const {
        'spreadsheetId': 'sheet-1',
        'sourceRange': "'Receipts'!A:Z",
      },
    );

    expect(resolved, isNotNull);
    expect(resolved!.presetKey, ReceiptIntelligencePreset.key);
    expect(resolved.inputs['analysisMode'], 'weekly-budget');
  });

  test('ReceiptMigration_WhenLegacyInstanceExists_UpdatesPresetAndInputs',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime.utc(2026, 8, 31);
    await db
        .into(db.workflowInstances)
        .insert(
          WorkflowInstancesCompanion.insert(
            id: 'legacy-instance',
            presetKey: 'receipt-weekly-budget',
            presetVersion: 1,
            name: 'Weekly budget',
            topic: 'Weekly budget',
            createdAtUtc: now,
            updatedAtUtc: now,
          ),
        );
    await db
        .into(db.schedules)
        .insert(
          SchedulesCompanion.insert(
            localWorkflowId: 'legacy-instance',
            localTime: '09:00',
            timeZoneId: 'UTC',
            enabled: const Value(true),
            nextRunAtUtc: now,
            recurrenceJson: const Value('{}'),
            workflowInputsJson: const Value('{"spreadsheetId":"sheet-1"}'),
            presetName: const Value('Weekly budget'),
          ),
        );

    await migrateLegacyReceiptWorkflows(db);

    final instance = await (db.select(
      db.workflowInstances,
    )..where((row) => row.id.equals('legacy-instance'))).getSingle();
    expect(instance.presetKey, ReceiptIntelligencePreset.key);

    final schedule = await (db.select(
      db.schedules,
    )..where((row) => row.localWorkflowId.equals('legacy-instance'))).getSingle();
    final inputs =
        jsonDecode(schedule.workflowInputsJson) as Map<String, dynamic>;
    expect(inputs['analysisMode'], 'weekly-budget');
  });

  test('ReceiptReport_WhenBackendHtmlPresent_UsesRenderedHtml', () {
    final html = File(
      'test/presets/receipt_workflows/fixtures/receipt_report.html',
    ).readAsStringSync();
    final run = WorkflowRun(
      runId: 'receipt-run',
      presetKey: ReceiptIntelligencePreset.key,
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

  test('EntryWorkflowNode_WhenIntegrationStartsWorkflow_ReturnsFirstStep', () {
    final details = receiptTestDetails();

    expect(details.entryWorkflowNode()?.displayName, 'Read receipt sheet');
    expect(details.entryWorkflowNode()?.type, 'Integration');
    expect(details.primaryWorkflowAgent()?.key, receiptReportWriterAgentKey);
  });
}
