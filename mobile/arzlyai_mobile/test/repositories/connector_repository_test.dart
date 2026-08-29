import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/storage/device/device_id_store.dart';
import 'package:arzlyai_mobile/core/network/services/connectors/connector_service.dart';
import 'package:arzlyai_mobile/data/repositories/connector_auth_launcher.dart';
import 'package:arzlyai_mobile/data/repositories/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/connector_repository.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/connector_credential_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/connector_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../storage/device_id_store_test.dart';

Map<String, dynamic> _fixture(String name) {
  return jsonDecode(
    File('test/fixtures/network/$name').readAsStringSync(),
  ) as Map<String, dynamic>;
}

ConnectorRepository _repository(
  AppDatabase db,
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
  final service = ConnectorService(ApiExecutor(dio), DeviceIdStore(storage));
  return ConnectorRepository(
    service,
    ConnectorCredentialRepository(db),
    ConnectorAuthLauncher(),
    const ConnectorMapper(),
    const ConnectorCredentialMapper(),
  );
}

void main() {
  late AppDatabase db;
  late MemorySecureStorage storage;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    storage = MemorySecureStorage();
  });

  tearDown(() async {
    await db.close();
  });

  test('syncCredentials stores linkedin envelope keys locally', () async {
    final repository = _repository(
      db,
      storage,
      onRequest: (options) async {
        return Response(
          requestOptions: options,
          data: _fixture('connector_credentials_linkedin.json'),
          statusCode: 200,
        );
      },
    );
    final local = ConnectorCredentialRepository(db);

    await repository.syncCredentials(ConnectorKeys.linkedin);

    expect(await local.isConnected(ConnectorKeys.linkedin), isTrue);
    expect(
      await local.readEnvelopeValues(ConnectorKeys.linkedin),
      {
        integrationFieldEnvelopeKey('linkedin.posts', 'accessToken'):
            'li-access-token',
        integrationFieldEnvelopeKey('linkedin.posts', 'authorUrn'):
            'urn:li:person:abc123',
      },
    );
  });

  test('syncCredentials rejects partial response without overwriting', () async {
    final local = ConnectorCredentialRepository(db);
    await local.saveFields(ConnectorKeys.linkedin, {
      LinkedInConnectorFields.accessToken: 'keep-token',
      LinkedInConnectorFields.authorUrn: 'urn:li:person:keep',
    });

    final repository = _repository(
      db,
      storage,
      onRequest: (options) async {
        return Response(
          requestOptions: options,
          data: {'linkedin.accessToken': 'new-token'},
          statusCode: 200,
        );
      },
    );

    await expectLater(
      repository.syncCredentials(ConnectorKeys.linkedin),
      throwsA(isA<StateError>()),
    );
    expect(
      await local.readEnvelopeValues(ConnectorKeys.linkedin),
      {
        integrationFieldEnvelopeKey('linkedin.posts', 'accessToken'):
            'keep-token',
        integrationFieldEnvelopeKey('linkedin.posts', 'authorUrn'):
            'urn:li:person:keep',
      },
    );
  });

  test('disconnect 204 clears local credentials', () async {
    final local = ConnectorCredentialRepository(db);
    await local.saveFields(ConnectorKeys.linkedin, {
      LinkedInConnectorFields.accessToken: 'li-token',
      LinkedInConnectorFields.authorUrn: 'urn:li:person:1',
    });

    final repository = _repository(
      db,
      storage,
      onRequest: (options) async {
        if (options.method == 'DELETE') {
          return Response(requestOptions: options, statusCode: 204);
        }
        return Response(requestOptions: options, data: {}, statusCode: 404);
      },
    );

    await repository.disconnect(ConnectorKeys.linkedin);
    expect(await local.isConnected(ConnectorKeys.linkedin), isFalse);
  });

  test('disconnect 404 preserves local credentials', () async {
    final local = ConnectorCredentialRepository(db);
    await local.saveFields(ConnectorKeys.linkedin, {
      LinkedInConnectorFields.accessToken: 'li-token',
      LinkedInConnectorFields.authorUrn: 'urn:li:person:1',
    });

    final repository = _repository(
      db,
      storage,
      onRequest: (options) async {
        return Response(requestOptions: options, data: {}, statusCode: 404);
      },
    );

    await expectLater(
      repository.disconnect(ConnectorKeys.linkedin),
      throwsA(isA<ApiException>()),
    );
    expect(await local.isConnected(ConnectorKeys.linkedin), isTrue);
  });
}
