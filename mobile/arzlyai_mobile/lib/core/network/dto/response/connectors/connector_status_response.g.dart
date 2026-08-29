// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConnectorStatusResponse _$ConnectorStatusResponseFromJson(
  Map<String, dynamic> json,
) => _ConnectorStatusResponse(
  connectorKey: json['connectorKey'] as String,
  isConnected: json['isConnected'] as bool,
  connectedAtUtc: json['connectedAtUtc'] == null
      ? null
      : DateTime.parse(json['connectedAtUtc'] as String),
);

Map<String, dynamic> _$ConnectorStatusResponseToJson(
  _ConnectorStatusResponse instance,
) => <String, dynamic>{
  'connectorKey': instance.connectorKey,
  'isConnected': instance.isConnected,
  'connectedAtUtc': instance.connectedAtUtc?.toIso8601String(),
};
