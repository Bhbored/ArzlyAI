import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/client/dio_client.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_sheet_headers_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_sheet_tab_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/google_spreadsheet_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/connector_session_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/connector_status_response.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';
import 'package:arzlyai_mobile/core/storage/device/device_id_store.dart';

part 'connector_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ConnectorService connectorService(Ref ref) {
  final dioClient = ref.read(dioClientProvider(null, endpoint: ''));
  final apiExecutor = ref.read(apiExecutorProvider(dioClient.dio));
  return ConnectorService(apiExecutor, ref.read(deviceIdStoreProvider));
}

class ConnectorService {
  ConnectorService(this._apiExecutor, this._deviceIdStore);

  final ApiExecutor _apiExecutor;
  final DeviceIdStore _deviceIdStore;
  final _logger = Logger();

  Future<ConnectorSessionResponse> createSession(String connectorKey) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'connectors/$connectorKey/session',
        method: HttpMethod.post,
        headers: await _deviceHeaders(),
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        _logger.i('Connector session created');
        return ConnectorSessionResponse.fromJson(data as Map<String, dynamic>);
      },
      failure: (error, statusCode) {
        _logger.e('Failed to create connector session');
        throw error;
      },
    );
  }

  Future<ConnectorStatusResponse> getStatus(String connectorKey) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'connectors/$connectorKey/status',
        method: HttpMethod.get,
        headers: await _deviceHeaders(),
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        _logger.i('Connector status retrieved');
        return ConnectorStatusResponse.fromJson(data as Map<String, dynamic>);
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve connector status');
        throw error;
      },
    );
  }

  Future<Map<String, String>?> getCredentials(String connectorKey) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'connectors/$connectorKey/credentials',
        method: HttpMethod.get,
        headers: await _deviceHeaders(),
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        if (statusCode == 404) return null;
        _logger.i('Connector credentials retrieved');
        return _parseCredentialMap(data);
      },
      failure: (error, statusCode) {
        if (statusCode == 404) return null;
        _logger.e('Failed to retrieve connector credentials');
        throw error;
      },
    );
  }

  Future<bool> disconnect(String connectorKey) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'connectors/$connectorKey',
        method: HttpMethod.delete,
        headers: await _deviceHeaders(),
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        if (statusCode == 204) {
          _logger.i('Connector disconnected');
          return true;
        }
        return false;
      },
      failure: (error, statusCode) {
        if (statusCode == 404) return false;
        _logger.e('Failed to disconnect connector');
        throw error;
      },
    );
  }

  Future<List<GoogleSpreadsheetResponse>> listGoogleSpreadsheets() async {
    final data = await _getGoogleResource(
      'connectors/google-sheets/resources/spreadsheets',
    );
    return (data as List<dynamic>)
        .map(
          (item) =>
              GoogleSpreadsheetResponse.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<List<GoogleSheetTabResponse>> listGoogleTabs(
    String spreadsheetId,
  ) async {
    final id = Uri.encodeComponent(spreadsheetId);
    final data = await _getGoogleResource(
      'connectors/google-sheets/resources/spreadsheets/$id/tabs',
    );
    return (data as List<dynamic>)
        .map(
          (item) =>
              GoogleSheetTabResponse.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<GoogleSheetHeadersResponse> listGoogleHeaders(
    String spreadsheetId,
    String tabTitle,
  ) async {
    final id = Uri.encodeComponent(spreadsheetId);
    final title = Uri.encodeComponent(tabTitle);
    final data = await _getGoogleResource(
      'connectors/google-sheets/resources/spreadsheets/$id/tabs/$title/headers',
    );
    return GoogleSheetHeadersResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<dynamic> _getGoogleResource(String path) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: path,
        method: HttpMethod.get,
        headers: await _deviceHeaders(),
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

  Future<Map<String, String>> _deviceHeaders() async {
    final deviceId = await _deviceIdStore.getOrCreate();
    return {'X-Device-Id': deviceId};
  }

  Map<String, String> _parseCredentialMap(dynamic data) {
    if (data is! Map) return {};
    return {
      for (final entry in data.entries)
        if (entry.key is String && entry.value is String)
          entry.key as String: entry.value as String,
    };
  }
}
