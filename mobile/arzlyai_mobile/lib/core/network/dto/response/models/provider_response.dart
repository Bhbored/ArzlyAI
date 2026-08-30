import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_response.freezed.dart';
part 'provider_response.g.dart';

@freezed
sealed class ProviderResponse with _$ProviderResponse {
  const factory ProviderResponse({
    required String key,
    required String displayName,
  }) = _ProviderResponse;

  factory ProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$ProviderResponseFromJson(json);
}
