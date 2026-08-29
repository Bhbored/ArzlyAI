import 'package:freezed_annotation/freezed_annotation.dart';

part 'connector_session_response.freezed.dart';
part 'connector_session_response.g.dart';

@freezed
sealed class ConnectorSessionResponse with _$ConnectorSessionResponse {
  const factory ConnectorSessionResponse({
    required String connectUrl,
    required String sessionToken,
    required DateTime expiresAtUtc,
  }) = _ConnectorSessionResponse;

  factory ConnectorSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectorSessionResponseFromJson(json);
}
