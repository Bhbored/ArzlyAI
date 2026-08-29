import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';

part 'list_openai_models_request.freezed.dart';
part 'list_openai_models_request.g.dart';

@freezed
sealed class ListOpenAiModelsRequest with _$ListOpenAiModelsRequest {
  const factory ListOpenAiModelsRequest({
    required CredentialEnvelope credentials,
  }) = _ListOpenAiModelsRequest;

  factory ListOpenAiModelsRequest.fromJson(Map<String, dynamic> json) =>
      _$ListOpenAiModelsRequestFromJson(json);
}
