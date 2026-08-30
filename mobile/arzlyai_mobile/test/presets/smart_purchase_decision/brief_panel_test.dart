import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_brief_panel.dart';

void main() {
  testWidgets('BriefPanel_WhenRestatementJson_ShowsSummaryAndChecklist', (
    tester,
  ) async {
    const content =
        '{"summary":"A quiet vacuum under \$200 for pets","checklist":["Quiet","Under \$200","Good for pets"],"countryCode":"US","currencyCode":"USD","budget":"200"}';
    await tester.pumpWidget(
      ShadApp.custom(
        theme: ShadThemeData(
          brightness: Brightness.dark,
          colorScheme: const ShadZincColorScheme.dark(),
        ),
        appBuilder: (context) => MaterialApp(
          home: Scaffold(
            body: SmartPurchaseBriefPanel(content: content),
          ),
        ),
      ),
    );

    expect(find.text('Does this look right?'), findsOneWidget);
    expect(find.textContaining('quiet vacuum'), findsOneWidget);
    expect(find.text('Quiet'), findsOneWidget);
    expect(find.textContaining('Shopping in US'), findsOneWidget);
  });
}
