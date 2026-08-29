import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/storage/device/device_id_store.dart';
import 'package:arzlyai_mobile/core/network/services/connectors/connector_service.dart';
import '../storage/device_id_store_test.dart';

Map<String, dynamic> _fixture(String name) {
  return jsonDecode(
    File('test/fixtures/network/$name').readAsStringSync(),
  ) as Map<String, dynamic>;
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
        return Response(
          requestOptions: options,
          data: {},
          statusCode: 404,
        );
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
}
