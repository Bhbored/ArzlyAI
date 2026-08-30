import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/core/network/services/connectors/connector_service.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_headers.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_tab.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_spreadsheet.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/google_resource_mapper.dart';

final googleResourceRepositoryProvider = Provider<GoogleResourceRepository>((
  ref,
) {
  return GoogleResourceRepository(
    ref.watch(connectorServiceProvider),
    const GoogleResourceMapper(),
  );
});

class GoogleResourceRepository {
  const GoogleResourceRepository(this._service, this._mapper);

  final ConnectorService _service;
  final GoogleResourceMapper _mapper;

  Future<List<GoogleSpreadsheet>> listSpreadsheets() async {
    final response = await _service.listGoogleSpreadsheets();
    return response.map(_mapper.spreadsheet).toList(growable: false);
  }

  Future<List<GoogleSheetTab>> listTabs(String spreadsheetId) async {
    final response = await _service.listGoogleTabs(spreadsheetId);
    return response.map(_mapper.tab).toList(growable: false);
  }

  Future<GoogleSheetHeaders> listHeaders(
    String spreadsheetId,
    String tabTitle,
  ) async {
    final response = await _service.listGoogleHeaders(spreadsheetId, tabTitle);
    return _mapper.headers(response);
  }
}
