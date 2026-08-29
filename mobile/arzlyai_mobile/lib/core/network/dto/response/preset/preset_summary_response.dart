import 'package:freezed_annotation/freezed_annotation.dart';

part 'preset_summary_response.freezed.dart';
part 'preset_summary_response.g.dart';

@freezed
sealed class PresetSummaryResponse with _$PresetSummaryResponse {
  const factory PresetSummaryResponse({
    required String id,
    required String key,
    required String name,
    required String description,
    required int version,
  }) = _PresetSummaryResponse;

  factory PresetSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$PresetSummaryResponseFromJson(json);
}
