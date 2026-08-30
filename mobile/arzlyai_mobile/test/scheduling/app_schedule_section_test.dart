import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/google_sheet_selection_temp.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_schedule_section.dart';

void main() {
  test('scheduled model override persists provider and model', () {
    final details = const PresetMapper().detailsFromDto(
      PresetDetailsResponse.fromJson(
        jsonDecode(
              File(
                'test/presets/daily_linkedin_ai_post/fixtures/preset_details.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>,
      ),
    );

    final encoded = buildScheduleModelOverridesJson(
      details,
      const RunConfigState(
        topic: 'AI',
        provider: 'anthropic',
        model: 'claude-sonnet-4-20250514',
        temperature: 0.4,
      ),
    );
    final override =
        (jsonDecode(encoded!) as List<dynamic>).single as Map<String, dynamic>;

    expect(override['agentKey'], 'content-writer');
    expect(override['provider'], 'anthropic');
    expect(override['model'], 'claude-sonnet-4-20250514');
    expect(override['temperature'], 0.4);
  });

  test('scheduled legacy model selection infers provider', () {
    final details = const PresetMapper().detailsFromDto(
      PresetDetailsResponse.fromJson(
        jsonDecode(
              File(
                'test/presets/daily_linkedin_ai_post/fixtures/preset_details.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>,
      ),
    );

    final encoded = buildScheduleModelOverridesJson(
      details,
      const RunConfigState(topic: 'AI', model: 'gemini-2.5-flash'),
    );
    final override =
        (jsonDecode(encoded!) as List<dynamic>).single as Map<String, dynamic>;

    expect(override['provider'], 'gemini');
  });

  for (final presetKey in [
    'receipt-monthly-spending',
    'receipt-weekly-budget',
    'receipt-quarterly-tax',
    'receipt-yearly-review',
    'receipt-category-dive',
    'receipt-anomaly-detector',
    'receipt-savings-tracker',
  ]) {
    test('$presetKey stores complete delivery inputs', () {
      final inputs = buildScheduledWorkflowInputs(
        presetKey,
        const RunConfigState(
          inputs: {
            'range': 'A:Z',
            'asOfDate': '2026-08-31',
            'currencyCode': 'usd',
            'budget': '1000',
            'taxRate': '0.2',
            'category': 'Food',
            'recipientEmail': 'person@example.com',
          },
        ),
        const GoogleSheetSelectionState(
          spreadsheetId: 'sheet-1',
          tabTitle: "August's receipts",
          headerMapping: {
            'date': 'Date',
            'merchant': 'Merchant',
            'category': 'Category',
            'amount': 'Amount',
          },
        ),
      );

      expect(inputs['spreadsheetId'], 'sheet-1');
      expect(inputs['sourceRange'], "'August''s receipts'!A:Z");
      expect(inputs['currencyCode'], 'USD');
      expect(inputs['deliveryMode'], 'deliver');
      expect(jsonDecode(inputs['columnMappingJson']!)['merchant'], 'Merchant');
    });
  }

  test('receipt schedule rejects incomplete source configuration', () {
    expect(
      () => buildScheduledWorkflowInputs(
        'receipt-monthly-spending',
        const RunConfigState(),
        const GoogleSheetSelectionState(),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('scheduled receipt model overrides preserve selected provider', () {
    final details = const PresetMapper().detailsFromDto(
      PresetDetailsResponse.fromJson(
        jsonDecode(
              File(
                'test/presets/daily_linkedin_ai_post/fixtures/preset_details.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>,
      ),
    );
    final encoded = buildScheduleModelOverridesJson(
      details,
      const RunConfigState(
        agentOverrides: {
          'content-writer': AgentOverrideDraft(
            provider: 'anthropic',
            model: 'claude-sonnet-4-20250514',
            temperature: 0.3,
          ),
        },
      ),
    );
    final override =
        (jsonDecode(encoded!) as List<dynamic>).single as Map<String, dynamic>;
    expect(override['provider'], 'anthropic');
    expect(override['model'], 'claude-sonnet-4-20250514');
  });
}
