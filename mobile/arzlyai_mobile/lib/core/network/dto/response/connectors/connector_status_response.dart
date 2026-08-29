import 'package:freezed_annotation/freezed_annotation.dart';

part 'connector_status_response.freezed.dart';
part 'connector_status_response.g.dart';

@freezed
sealed class ConnectorStatusResponse with _$ConnectorStatusResponse {
  const factory ConnectorStatusResponse({
    required String connectorKey,
    required bool isConnected,
    DateTime? connectedAtUtc,
  }) = _ConnectorStatusResponse;

  factory ConnectorStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectorStatusResponseFromJson(json);
}
