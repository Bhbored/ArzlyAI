import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/ui/features/presets/catalog/preset_catalog_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/details/preset_details_screen.dart';
import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';

void main() {
  testWidgets('preset details shows workflow graph nodes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetDetailsProvider.overrideWith(() => SeededDetails(fixtureDetails())),
        ],
        child: testApp(home: const PresetDetailsScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Workflow'), findsOneWidget);
    expect(find.text('AI Content Writer'), findsOneWidget);
    expect(find.text('Review Content'), findsOneWidget);
    expect(find.text('LinkedIn Publisher'), findsOneWidget);
    expect(find.text('Post to LinkedIn'), findsOneWidget);
    expect(find.text('Human approval'), findsOneWidget);
    expect(find.text('Integration'), findsOneWidget);
    expect(find.text('Publish text posts to LinkedIn.'), findsOneWidget);
    expect(find.text('linkedin.posts'), findsOneWidget);
    expect(find.text('Access token'), findsOneWidget);
    expect(find.text('Author urn'), findsOneWidget);
  });

  testWidgets('catalog surfaces accessible errors with correlation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetCatalogProvider.overrideWith(FailingCatalog.new),
        ],
        child: testApp(home: const PresetCatalogScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Catalog unavailable'), findsOneWidget);
    expect(find.text('corr-1'), findsOneWidget);
    expect(find.text('Presets'), findsOneWidget);
  });

  testWidgets('catalog opens details for a preset', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetCatalogProvider.overrideWith(() => SeededCatalog([fixtureSummary()])),
          presetDetailsProvider.overrideWith(() => SeededDetails(fixtureDetails())),
        ],
        child: testApp(home: const PresetCatalogScreen()),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Daily LinkedIn AI Post'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Review Content'), findsOneWidget);
    expect(find.text('Tap a step to configure or view details.'), findsOneWidget);
  });
}
