import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart';

import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';

import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';

import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';

import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';

import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';

import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';

import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/configure_run_screen.dart';

import '../../helpers/fakes.dart';

import '../../helpers/test_app.dart';

List<Override> _configureOverrides() => [
  presetDetailsProvider.overrideWith(() => SeededDetails(fixtureDetails())),

  availableProviderModelsProvider.overrideWith(
    () => SeededAvailableProviderModels(fixtureProviderModels()),
  ),

  defaultAiModelProvider.overrideWith((ref) async => null),

  internetConnectionProvider.overrideWithValue(true),

  offlineModeProvider.overrideWith(OnlineMode.new),
];

void main() {
  testWidgets(
    'configure shows online models without temperature for default model',

    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: _configureOverrides(),

          child: testApp(home: const ConfigureRunScreen()),
        ),
      );

      await tester.pump();

      expect(find.byType(ShadSelect<String>), findsOneWidget);

      expect(find.text('GPT-5 Mini (openai)'), findsOneWidget);

      expect(find.byType(Slider), findsNothing);

      final button = tester.widget<ShadButton>(find.byType(ShadButton).last);

      expect(button.onPressed, isNull);
    },
  );

  testWidgets('temperature slider appears for supporting model', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _configureOverrides(),

        child: testApp(home: const ConfigureRunScreen()),
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(ShadSelect<String>));

    await tester.pumpAndSettle();

    await tester.tap(find.text('GPT 4.1 Mini (openai)').last);

    await tester.pumpAndSettle();

    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets(
    'switching away from supporting model clears temperature override',

    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: _configureOverrides(),

          child: testApp(home: const ConfigureRunScreen()),
        ),
      );

      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ConfigureRunScreen)),
      );

      container
          .read(runConfigTempProvider.notifier)
          .update(
            const RunConfigState(
              topic: 'AI agents',

              provider: 'openai',

              model: 'gpt-4.1-mini',

              temperature: 0.4,
            ),
          );

      await tester.pump();

      expect(find.byType(Slider), findsOneWidget);

      await tester.tap(find.byType(ShadSelect<String>));

      await tester.pumpAndSettle();

      await tester.tap(find.text('GPT-5 Mini (openai)').last);

      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsNothing);

      expect(container.read(runConfigTempProvider).temperature, isNull);
    },
  );

  testWidgets('offline mode disables generate even with a topic', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetDetailsProvider.overrideWith(
            () => SeededDetails(fixtureDetails()),
          ),
          availableProviderModelsProvider.overrideWith(
            () => SeededAvailableProviderModels(fixtureProviderModels()),
          ),
          defaultAiModelProvider.overrideWith((ref) async => null),
          internetConnectionProvider.overrideWithValue(false),
          offlineModeProvider.overrideWith(OnlineMode.new),
        ],

        child: testApp(home: const ConfigureRunScreen()),
      ),
    );

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ConfigureRunScreen)),
    );

    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));

    await tester.pump();

    final button = tester.widget<ShadButton>(find.byType(ShadButton).last);

    expect(button.onPressed, isNull);
  });
}
