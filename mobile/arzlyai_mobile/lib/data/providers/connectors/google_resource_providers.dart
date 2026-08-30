import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/data/repositories/connectors/google_resource_repository.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_headers.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_tab.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_spreadsheet.dart';

final googleSpreadsheetsProvider =
    FutureProvider.autoDispose<List<GoogleSpreadsheet>>((ref) {
      return ref.watch(googleResourceRepositoryProvider).listSpreadsheets();
    });

final googleSheetTabsProvider = FutureProvider.autoDispose
    .family<List<GoogleSheetTab>, String>((ref, spreadsheetId) {
      return ref
          .watch(googleResourceRepositoryProvider)
          .listTabs(spreadsheetId);
    });

typedef GoogleSheetHeadersQuery = ({String spreadsheetId, String tabTitle});

final googleSheetHeadersProvider = FutureProvider.autoDispose
    .family<GoogleSheetHeaders, GoogleSheetHeadersQuery>((ref, query) {
      return ref
          .watch(googleResourceRepositoryProvider)
          .listHeaders(query.spreadsheetId, query.tabTitle);
    });
