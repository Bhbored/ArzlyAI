import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_option_response.freezed.dart';
part 'model_option_response.g.dart';

@freezed
sealed class ModelOptionResponse with _$ModelOptionResponse {
  const factory ModelOptionResponse({
    required String provider,
    required String model,
    required String displayName,
  }) = _ModelOptionResponse;

  factory ModelOptionResponse.fromJson(Map<String, dynamic> json) =>
      _$ModelOptionResponseFromJson(json);
}
