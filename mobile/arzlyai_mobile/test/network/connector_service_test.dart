import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/storage/device/device_id_store.dart';
import 'package:arzlyai_mobile/core/network/services/connectors/connector_service.dart';
import '../storage/device_id_store_test.dart';

dynamic _fixture(String name) {
  return jsonDecode(File('test/fixtures/network/$name').readAsStringSync());
}

ConnectorService _service(
  MemorySecureStorage storage, {
  required Future<Response<dynamic>> Function(RequestOptions options) onRequest,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.example/api/v1/'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        handler.resolve(await onRequest(options));
      },
    ),
  );
  return ConnectorService(ApiExecutor(dio), DeviceIdStore(storage));
}

void main() {
  late MemorySecureStorage storage;

  setUp(() {
    storage = MemorySecureStorage();
  });

  test('createSession sends X-Device-Id', () async {
    String? deviceHeader;
    final service = _service(
      storage,
      onRequest: (options) async {
        deviceHeader = options.headers['X-Device-Id'] as String?;
        return Response(
          requestOptions: options,
          data: _fixture('connector_session.json'),
          statusCode: 200,
        );
      },
    );
    final session = await service.createSession('linkedin');
    expect(session.connectUrl, contains('nango.dev'));
    expect(deviceHeader, isNotNull);
    expect(deviceHeader!.isNotEmpty, isTrue);
    expect(await storage.getValue(DeviceIdStorageKeys.deviceId), deviceHeader);
  });

  test('getStatus sends X-Device-Id', () async {
    final service = _service(
      storage,
      onRequest: (options) async {
        expect(options.headers['X-Device-Id'], isNotEmpty);
        return Response(
          requestOptions: options,
          data: _fixture('connector_status.json'),
          statusCode: 200,
        );
      },
    );
    final status = await service.getStatus('linkedin');
    expect(status.isConnected, isTrue);
    expect(status.connectorKey, 'linkedin');
  });

  test('getCredentials returns map and 404 is null', () async {
    final service = _service(
      storage,
      onRequest: (options) async {
        return Response(
          requestOptions: options,
          data: _fixture('connector_credentials_linkedin.json'),
          statusCode: 200,
        );
      },
    );
    final credentials = await service.getCredentials('linkedin');
    expect(credentials?['linkedin.accessToken'], 'li-access-token');
    expect(credentials?['linkedin.authorUrn'], 'urn:li:person:abc123');

    final missingService = _service(
      storage,
      onRequest: (options) async {
        return Response(requestOptions: options, data: {}, statusCode: 404);
      },
    );
    final missing = await missingService.getCredentials('linkedin');
    expect(missing, isNull);
  });

  test('disconnect returns true on 204 and false on 404', () async {
    final okService = _service(
      storage,
      onRequest: (options) async {
        expect(options.method, 'DELETE');
        return Response(requestOptions: options, statusCode: 204);
      },
    );
    expect(await okService.disconnect('linkedin'), isTrue);

    final missingService = _service(
      storage,
      onRequest: (options) async {
        return Response(requestOptions: options, data: {}, statusCode: 404);
      },
    );
    expect(await missingService.disconnect('linkedin'), isFalse);
  });

  test('Google resource endpoints map spreadsheet metadata', () async {
    final paths = <String>[];
    final service = _service(
      storage,
      onRequest: (options) async {
        paths.add(options.path);
        final fixture = switch (options.path) {
          String path when path.endsWith('/headers') =>
            'google_sheet_headers.json',
          String path when path.endsWith('/tabs') => 'google_sheet_tabs.json',
          _ => 'google_spreadsheets.json',
        };
        return Response(
          requestOptions: options,
          data: _fixture(fixture),
          statusCode: 200,
        );
      },
    );

    final spreadsheets = await service.listGoogleSpreadsheets();
    final tabs = await service.listGoogleTabs('sheet/with slash');
    final headers = await service.listGoogleHeaders(
      'sheet/with slash',
      'August Receipts',
    );

    expect(spreadsheets.first.name, 'Receipts');
    expect(tabs.single.rowCount, 1000);
    expect(headers.headers, ['Date', 'Vendor', 'Amount']);
    expect(paths[1], contains('sheet%2Fwith%20slash'));
    expect(paths[2], contains('August%20Receipts'));
    expect(await storage.getValue(DeviceIdStorageKeys.deviceId), isNotNull);
  });
}
