import 'package:freezed_annotation/freezed_annotation.dart';

part 'connector_status.freezed.dart';

@freezed
sealed class ConnectorStatus with _$ConnectorStatus {
  const factory ConnectorStatus({
    required String connectorKey,
    required bool isConnected,
    DateTime? connectedAtUtc,
  }) = _ConnectorStatus;
}
