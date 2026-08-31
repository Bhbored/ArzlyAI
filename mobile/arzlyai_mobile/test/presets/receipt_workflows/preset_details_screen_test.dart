import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/ui/features/presets/details/preset_details_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/configure_run_screen.dart';

import '../../helpers/test_app.dart';
import 'receipt_workflows_test.dart';

void main() {
  testWidgets('ReceiptDetails_WhenFirstStepTapped_OpensConfigureRun', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetDetailsProvider.overrideWith(
            () => _SeededDetails(receiptTestDetails()),
          ),
        ],
        child: testApp(home: const PresetDetailsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Read receipt sheet'));
    await tester.pumpAndSettle();

    expect(find.byType(ReceiptConfigureRunScreen), findsOneWidget);
    expect(find.text('What do you want to learn?'), findsOneWidget);
  });
}

class _SeededDetails extends PresetDetailsNotifier {
  _SeededDetails(this.details);

  final PresetDetails details;

  @override
  Future<PresetDetails?> build() async => details;
}
