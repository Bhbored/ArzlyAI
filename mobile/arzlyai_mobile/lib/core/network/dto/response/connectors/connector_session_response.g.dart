// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConnectorSessionResponse _$ConnectorSessionResponseFromJson(
  Map<String, dynamic> json,
) => _ConnectorSessionResponse(
  connectUrl: json['connectUrl'] as String,
  sessionToken: json['sessionToken'] as String,
  expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
);

Map<String, dynamic> _$ConnectorSessionResponseToJson(
  _ConnectorSessionResponse instance,
) => <String, dynamic>{
  'connectUrl': instance.connectUrl,
  'sessionToken': instance.sessionToken,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
};
