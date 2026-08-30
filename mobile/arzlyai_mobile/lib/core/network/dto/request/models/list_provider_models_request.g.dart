// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_provider_models_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListProviderModelsRequest _$ListProviderModelsRequestFromJson(
  Map<String, dynamic> json,
) => _ListProviderModelsRequest(
  credentials: CredentialEnvelope.fromJson(
    json['credentials'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ListProviderModelsRequestToJson(
  _ListProviderModelsRequest instance,
) => <String, dynamic>{'credentials': instance.credentials.toJson()};
