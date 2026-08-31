import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/client/dio_client.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_sheet_headers_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_sheet_tab_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_spreadsheet_response.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';

part 'connector_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ConnectorService connectorService(Ref ref) {
  final dioClient = ref.read(dioClientProvider(null, endpoint: ''));
  final apiExecutor = ref.read(apiExecutorProvider(dioClient.dio));
  return ConnectorService(apiExecutor);
}

class ConnectorService {
  ConnectorService(this._apiExecutor);

  final ApiExecutor _apiExecutor;
  final _logger = Logger();

  Future<List<GoogleSpreadsheetResponse>> queryGoogleSpreadsheets(
    CredentialEnvelope credentials,
  ) async {
    final data = await _postGoogleResource(
      'connectors/google-sheets/resources/spreadsheets/query',
      credentials,
    );
    return (data as List<dynamic>)
        .map(
          (item) =>
              GoogleSpreadsheetResponse.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<List<GoogleSheetTabResponse>> queryGoogleTabs(
    String spreadsheetId,
    CredentialEnvelope credentials,
  ) async {
    final id = Uri.encodeComponent(spreadsheetId);
    final data = await _postGoogleResource(
      'connectors/google-sheets/resources/spreadsheets/$id/tabs/query',
      credentials,
    );
    return (data as List<dynamic>)
        .map(
          (item) =>
              GoogleSheetTabResponse.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<GoogleSheetHeadersResponse> queryGoogleHeaders(
    String spreadsheetId,
    String tabTitle,
    CredentialEnvelope credentials,
  ) async {
    final id = Uri.encodeComponent(spreadsheetId);
    final title = Uri.encodeComponent(tabTitle);
    final data = await _postGoogleResource(
      'connectors/google-sheets/resources/spreadsheets/$id/tabs/$title/headers/query',
      credentials,
    );
    return GoogleSheetHeadersResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<dynamic> _postGoogleResource(
    String path,
    CredentialEnvelope credentials,
  ) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: path,
        method: HttpMethod.post,
        data: {'credentials': credentials.toJson()},
      ),
    );
    return response.when(
      success: (data, statusCode, meta) => data,
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve Google resource metadata');
        throw error;
      },
    );
  }
}
