import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_model_response.freezed.dart';
part 'provider_model_response.g.dart';

@freezed
sealed class ProviderModelResponse with _$ProviderModelResponse {
  const factory ProviderModelResponse({
    required String id,
    required String displayName,
    required String provider,
    required String ownedBy,
    required DateTime createdAtUtc,
    required bool supportsTemperature,
    @Default(false) bool supportsWebSearch,
  }) = _ProviderModelResponse;

  factory ProviderModelResponse.fromJson(Map<String, dynamic> json) =>
      _$ProviderModelResponseFromJson(json);
}
