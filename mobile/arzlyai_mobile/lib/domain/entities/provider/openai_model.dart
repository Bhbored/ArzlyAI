import 'package:freezed_annotation/freezed_annotation.dart';

part 'openai_model.freezed.dart';

@freezed
sealed class OpenAiModel with _$OpenAiModel {
  const factory OpenAiModel({
    required String id,
    required String displayName,
    required String ownedBy,
    required DateTime createdAtUtc,
    required bool supportsTemperature,
    required bool supportsWebSearch,
  }) = _OpenAiModel;
}
