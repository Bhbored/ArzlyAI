import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_status_provider.dart';

part 'linkedin_connector_status_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(retry: retry)
Future<bool> linkedInConnectorStatus(Ref ref) async {
  return ref.watch(connectorLocalStatusProvider(ConnectorKeys.linkedin).future);
}
