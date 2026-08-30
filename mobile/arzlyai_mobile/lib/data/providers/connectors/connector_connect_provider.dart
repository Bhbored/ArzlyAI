import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_status_provider.dart';
import 'package:arzlyai_mobile/data/repositories/connectors/connector_repository.dart';

part 'connector_connect_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class ConnectorConnect extends _$ConnectorConnect {
  CancelToken? _cancelToken;

  @override
  FutureOr<void> build(String connectorKey) {}

  Future<void> connect() async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    state = const AsyncLoading();
    try {
      await ref
          .read(connectorRepositoryProvider)
          .connect(connectorKey, cancelToken: _cancelToken);
      ref.invalidate(connectorLocalStatusProvider(connectorKey));
      ref.invalidate(connectorRemoteStatusProvider(connectorKey));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> finishConnecting() async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    state = const AsyncLoading();
    try {
      await ref
          .read(connectorRepositoryProvider)
          .finishConnecting(connectorKey, cancelToken: _cancelToken);
      ref.invalidate(connectorLocalStatusProvider(connectorKey));
      ref.invalidate(connectorRemoteStatusProvider(connectorKey));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> syncCredentials() async {
    state = const AsyncLoading();
    try {
      await ref.read(connectorRepositoryProvider).syncCredentials(connectorKey);
      ref.invalidate(connectorLocalStatusProvider(connectorKey));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> disconnect() async {
    state = const AsyncLoading();
    try {
      await ref.read(connectorRepositoryProvider).disconnect(connectorKey);
      ref.invalidate(connectorLocalStatusProvider(connectorKey));
      ref.invalidate(connectorRemoteStatusProvider(connectorKey));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  void cancel() {
    _cancelToken?.cancel();
    _cancelToken = null;
    if (state is AsyncLoading) {
      state = const AsyncData(null);
    }
  }
}
