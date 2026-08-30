import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/enums/preset_input_field_type.dart';

part 'input_schema.freezed.dart';

@freezed
sealed class PresetInputSchema with _$PresetInputSchema {
  const factory PresetInputSchema({
    required int version,
    required List<PresetInputField> fields,
  }) = _PresetInputSchema;
}

@freezed
sealed class PresetInputField with _$PresetInputField {
  const factory PresetInputField({
    required String key,
    required String label,
    required PresetInputFieldType type,
    @Default(false) bool required,
    int? maxLength,
    num? minimum,
    int? maximumItems,
  }) = _PresetInputField;
}

@freezed
sealed class CandidateSeed with _$CandidateSeed {
  const factory CandidateSeed({
    required String label,
    String? url,
  }) = _CandidateSeed;
}
