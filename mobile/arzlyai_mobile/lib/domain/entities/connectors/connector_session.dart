import 'package:freezed_annotation/freezed_annotation.dart';

part 'connector_session.freezed.dart';

@freezed
sealed class ConnectorSession with _$ConnectorSession {
  const factory ConnectorSession({
    required String connectUrl,
    required String sessionToken,
    required DateTime expiresAtUtc,
  }) = _ConnectorSession;
}
