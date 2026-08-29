import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_catalog_provider.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_catalog_screen.dart';
import 'helpers/fakes.dart';
import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('app launches catalog', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetCatalogProvider.overrideWith(
            () => SeededCatalog([fixtureSummary()]),
          ),
        ],
        child: testApp(home: const PresetCatalogScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Presets'), findsOneWidget);
    expect(find.text('Daily LinkedIn AI Post'), findsOneWidget);
  });
}
