import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleSheetSelectionTempProvider =
    NotifierProvider<GoogleSheetSelectionTemp, GoogleSheetSelectionState>(
      GoogleSheetSelectionTemp.new,
    );

class GoogleSheetSelectionState {
  const GoogleSheetSelectionState({
    this.spreadsheetId,
    this.tabTitle,
    this.header,
    this.headerMapping = const {},
  });

  final String? spreadsheetId;
  final String? tabTitle;
  final String? header;
  final Map<String, String> headerMapping;

  GoogleSheetSelectionState copyWith({
    String? spreadsheetId,
    String? tabTitle,
    String? header,
    Map<String, String>? headerMapping,
    bool clearSpreadsheet = false,
    bool clearTab = false,
    bool clearHeader = false,
    bool clearHeaders = false,
  }) {
    return GoogleSheetSelectionState(
      spreadsheetId: clearSpreadsheet
          ? null
          : spreadsheetId ?? this.spreadsheetId,
      tabTitle: clearTab ? null : tabTitle ?? this.tabTitle,
      header: clearHeader ? null : header ?? this.header,
      headerMapping: clearHeaders
          ? const {}
          : headerMapping ?? this.headerMapping,
    );
  }
}

class GoogleSheetSelectionTemp extends Notifier<GoogleSheetSelectionState> {
  @override
  GoogleSheetSelectionState build() => const GoogleSheetSelectionState();

  void update(GoogleSheetSelectionState next) => state = next;

  void clear() => state = const GoogleSheetSelectionState();
}
