import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_sheet_headers_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_sheet_tab_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_spreadsheet_response.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_headers.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_tab.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_spreadsheet.dart';

class GoogleResourceMapper {
  const GoogleResourceMapper();

  GoogleSpreadsheet spreadsheet(GoogleSpreadsheetResponse dto) {
    return GoogleSpreadsheet(
      id: dto.id,
      name: dto.name,
      modifiedAtUtc: dto.modifiedAtUtc,
    );
  }

  GoogleSheetTab tab(GoogleSheetTabResponse dto) {
    return GoogleSheetTab(
      id: dto.id,
      title: dto.title,
      index: dto.index,
      rowCount: dto.rowCount,
      columnCount: dto.columnCount,
    );
  }

  GoogleSheetHeaders headers(GoogleSheetHeadersResponse dto) {
    return GoogleSheetHeaders(values: dto.headers);
  }
}
