import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/services/connectors/connector_service.dart';
import '../helpers/fakes.dart';

dynamic _fixture(String name) {
  return jsonDecode(File('test/fixtures/network/$name').readAsStringSync());
}

ConnectorService _service({
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
  return ConnectorService(ApiExecutor(dio));
}

void main() {
  test('Google resource query endpoints post credential envelope', () async {
    final paths = <String>[];
    final service = _service(
      onRequest: (options) async {
        paths.add('${options.method} ${options.path}');
        final fixture = switch (options.path) {
          String path when path.endsWith('/headers/query') =>
            'google_sheet_headers.json',
          String path when path.endsWith('/tabs/query') =>
            'google_sheet_tabs.json',
          _ => 'google_spreadsheets.json',
        };
        return Response(
          requestOptions: options,
          data: _fixture(fixture),
          statusCode: 200,
        );
      },
    );

    final spreadsheets = await service.queryGoogleSpreadsheets(dummyEnvelope);
    final tabs = await service.queryGoogleTabs('sheet/with slash', dummyEnvelope);
    final headers = await service.queryGoogleHeaders(
      'sheet/with slash',
      'August Receipts',
      dummyEnvelope,
    );

    expect(spreadsheets.first.name, 'Receipts');
    expect(tabs.single.rowCount, 1000);
    expect(headers.headers, ['Date', 'Vendor', 'Amount']);
    expect(paths.every((entry) => entry.startsWith('POST ')), isTrue);
    expect(paths[1], contains('sheet%2Fwith%20slash'));
    expect(paths[2], contains('August%20Receipts'));
  });
}
