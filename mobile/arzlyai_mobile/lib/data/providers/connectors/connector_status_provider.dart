import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/google/google_auth_provider.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';

part 'connector_status_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(retry: retry)
Future<bool> connectorLocalStatus(Ref ref, String connectorKey) async {
  if (ConnectorKeys.googleConnectors.contains(connectorKey)) {
    await ref.read(googleNativeAuthRepositoryProvider).restoreSilently();
    return ref.read(googleNativeAuthRepositoryProvider).isAuthorized(
      connectorKey,
    );
  }
  return ref
      .watch(connectorCredentialRepositoryProvider)
      .isConnected(connectorKey);
}
