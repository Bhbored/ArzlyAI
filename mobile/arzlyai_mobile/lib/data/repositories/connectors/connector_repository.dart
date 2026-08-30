import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/services/connectors/connector_service.dart';
import 'package:arzlyai_mobile/data/repositories/connectors/connector_auth_launcher.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/connector_session.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/connector_status.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/connector_credential_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/connector_mapper.dart';

part 'connector_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ConnectorRepository connectorRepository(Ref ref) {
  return ConnectorRepository(
    ref.read(connectorServiceProvider),
    ref.read(connectorCredentialRepositoryProvider),
    ref.read(connectorAuthLauncherProvider),
    const ConnectorMapper(),
    const ConnectorCredentialMapper(),
  );
}

class ConnectorRepository {
  ConnectorRepository(
    this._service,
    this._localCredentials,
    this._authLauncher,
    this._mapper,
    this._credentialMapper,
  );

  final ConnectorService _service;
  final ConnectorCredentialRepository _localCredentials;
  final ConnectorAuthLauncher _authLauncher;
  final ConnectorMapper _mapper;
  final ConnectorCredentialMapper _credentialMapper;

  Future<ConnectorSession> createSession(String connectorKey) async {
    final dto = await _service.createSession(connectorKey);
    return _mapper.sessionFromDto(dto);
  }

  Future<ConnectorStatus> fetchStatus(String connectorKey) async {
    final dto = await _service.getStatus(connectorKey);
    return _mapper.statusFromDto(dto);
  }

  Future<bool> isLocallyConnected(String connectorKey) {
    return _localCredentials.isConnected(connectorKey);
  }

  Future<void> connect(String connectorKey, {CancelToken? cancelToken}) async {
    _validateConnectorKey(connectorKey);
    final session = await createSession(connectorKey);
    await _authLauncher.launchConnect(connectorKey, session.connectUrl);
    await _pollUntilRemoteConnected(connectorKey, cancelToken: cancelToken);
    await syncCredentials(connectorKey);
  }

  Future<void> finishConnecting(
    String connectorKey, {
    CancelToken? cancelToken,
  }) async {
    _validateConnectorKey(connectorKey);
    await _pollUntilRemoteConnected(connectorKey, cancelToken: cancelToken);
    await syncCredentials(connectorKey);
  }

  Future<void> syncCredentials(String connectorKey) async {
    final apiValues = await _service.getCredentials(connectorKey);
    if (apiValues == null) {
      throw const ApiException(
        userMessage: 'Connector is not connected.',
        error: 'Connector credentials not found.',
        statusCode: 404,
        originalError: 'missing',
      );
    }
    await _persistValidatedCredentials(connectorKey, apiValues);
  }

  Future<void> disconnect(String connectorKey) async {
    final disconnected = await _service.disconnect(connectorKey);
    if (!disconnected) {
      throw const ApiException(
        userMessage: 'No remote connector connection was found.',
        error: 'Connector disconnect returned not found.',
        statusCode: 404,
        originalError: 'missing',
      );
    }
    await _localCredentials.deleteConnector(connectorKey);
  }

  Future<void> _pollUntilRemoteConnected(
    String connectorKey, {
    CancelToken? cancelToken,
    int maxAttempts = 12,
  }) async {
    var delay = const Duration(seconds: 2);
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (cancelToken?.isCancelled ?? false) {
        throw const ApiException(
          userMessage: 'Connection was cancelled.',
          error: 'Connector polling cancelled.',
          originalError: 'cancelled',
        );
      }
      final status = await fetchStatus(connectorKey);
      if (status.isConnected) return;
      await Future<void>.delayed(delay);
      if (cancelToken?.isCancelled ?? false) {
        throw const ApiException(
          userMessage: 'Connection was cancelled.',
          error: 'Connector polling cancelled.',
          originalError: 'cancelled',
        );
      }
      final nextMs = (delay.inMilliseconds * 150) ~/ 100;
      delay = Duration(milliseconds: nextMs > 8000 ? 8000 : nextMs);
    }
    throw TimeoutException('Connector authorization timed out.');
  }

  Future<void> _persistValidatedCredentials(
    String connectorKey,
    Map<String, String> apiValues,
  ) async {
    final localFields = _credentialMapper.localFields(connectorKey, apiValues);
    if (localFields == null) {
      throw StateError('$connectorKey credentials response was incomplete.');
    }
    await _localCredentials.saveFields(connectorKey, localFields);
  }

  void _validateConnectorKey(String connectorKey) {
    if (!ConnectorKeys.all.contains(connectorKey)) {
      throw ArgumentError('Unsupported connector key: $connectorKey');
    }
  }
}
