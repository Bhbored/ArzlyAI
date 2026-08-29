// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_openai_models_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListOpenAiModelsRequest _$ListOpenAiModelsRequestFromJson(
  Map<String, dynamic> json,
) => _ListOpenAiModelsRequest(
  credentials: CredentialEnvelope.fromJson(
    json['credentials'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ListOpenAiModelsRequestToJson(
  _ListOpenAiModelsRequest instance,
) => <String, dynamic>{'credentials': instance.credentials.toJson()};
