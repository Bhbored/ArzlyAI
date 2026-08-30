import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/data/providers/connectors/google_resource_providers.dart';
import 'package:arzlyai_mobile/data/providers/temp/google_sheet_selection_temp.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_headers.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_tab.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_spreadsheet.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_google_sheet_selector.dart';
import '../helpers/test_app.dart';

class _SeededSelection extends GoogleSheetSelectionTemp {
  @override
  GoogleSheetSelectionState build() {
    return const GoogleSheetSelectionState(
      spreadsheetId: 'sheet-1',
      tabTitle: 'August Receipts',
      header: 'Amount',
    );
  }
}

void main() {
  testWidgets('shows selected spreadsheet tab and header metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          googleSheetSelectionTempProvider.overrideWith(_SeededSelection.new),
          googleSpreadsheetsProvider.overrideWith((ref) async {
            return const [
              GoogleSpreadsheet(id: 'sheet-1', name: 'Receipts'),
            ];
          }),
          googleSheetTabsProvider('sheet-1').overrideWith((ref) async {
            return const [
              GoogleSheetTab(
                id: 101,
                title: 'August Receipts',
                index: 0,
                rowCount: 1000,
                columnCount: 26,
              ),
            ];
          }),
          googleSheetHeadersProvider((
            spreadsheetId: 'sheet-1',
            tabTitle: 'August Receipts',
          )).overrideWith((ref) async {
            return const GoogleSheetHeaders(
              values: ['Date', 'Vendor', 'Amount'],
            );
          }),
        ],
        child: testApp(home: const AppGoogleSheetSelector()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Google Sheets metadata'), findsOneWidget);
    expect(find.text('Receipts'), findsOneWidget);
    expect(find.text('August Receipts'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
  });
}
