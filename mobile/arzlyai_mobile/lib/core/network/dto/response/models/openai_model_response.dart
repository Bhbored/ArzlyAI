import 'package:freezed_annotation/freezed_annotation.dart';

part 'openai_model_response.freezed.dart';
part 'openai_model_response.g.dart';

@freezed
sealed class OpenAiModelResponse with _$OpenAiModelResponse {
  const factory OpenAiModelResponse({
    required String id,
    required String displayName,
    required String ownedBy,
    required DateTime createdAtUtc,
    required bool supportsTemperature,
    @Default(false) bool supportsWebSearch,
  }) = _OpenAiModelResponse;

  factory OpenAiModelResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenAiModelResponseFromJson(json);
}
