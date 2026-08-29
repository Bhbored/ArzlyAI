import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/repositories/connector_repository.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/connector_status.dart';

part 'connector_status_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(retry: retry)
Future<ConnectorStatus> connectorRemoteStatus(
  Ref ref,
  String connectorKey,
) async {
  return ref.watch(connectorRepositoryProvider).fetchStatus(connectorKey);
}

@Riverpod(retry: retry)
Future<bool> connectorLocalStatus(Ref ref, String connectorKey) async {
  return ref
      .watch(connectorRepositoryProvider)
      .isLocallyConnected(connectorKey);
}
