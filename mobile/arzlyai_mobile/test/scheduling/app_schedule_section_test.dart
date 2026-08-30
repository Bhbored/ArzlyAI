import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
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
}
