import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/ui/features/workflow_runs/configure_run_screen.dart';
import '../helpers/fakes.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('configure clamps temperature and keeps generate disabled without topic', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetDetailsProvider.overrideWith(() => SeededDetails(fixtureDetails())),
          internetConnectionProvider.overrideWithValue(true),
          offlineModeProvider.overrideWith(OnlineMode.new),
        ],
        child: testApp(home: const ConfigureRunScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('GPT-5 mini'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, 0);
    expect(slider.max, 1.5);
    expect(slider.value, 0.7);
    final button = tester.widget<ShadButton>(find.byType(ShadButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('offline mode disables generate even with a topic', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetDetailsProvider.overrideWith(() => SeededDetails(fixtureDetails())),
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
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await tester.pump();
    final button = tester.widget<ShadButton>(find.byType(ShadButton));
    expect(button.onPressed, isNull);
  });
}
