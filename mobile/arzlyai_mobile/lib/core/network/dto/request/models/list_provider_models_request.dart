import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';

part 'list_provider_models_request.freezed.dart';
part 'list_provider_models_request.g.dart';

@freezed
sealed class ListProviderModelsRequest with _$ListProviderModelsRequest {
  const factory ListProviderModelsRequest({
    required CredentialEnvelope credentials,
  }) = _ListProviderModelsRequest;

  factory ListProviderModelsRequest.fromJson(Map<String, dynamic> json) =>
      _$ListProviderModelsRequestFromJson(json);
}
