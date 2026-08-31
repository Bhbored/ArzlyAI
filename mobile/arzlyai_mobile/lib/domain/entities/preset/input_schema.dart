import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/enums/preset_input_field_type.dart';

part 'input_schema.freezed.dart';

@freezed
sealed class PresetInputSchema with _$PresetInputSchema {
  const factory PresetInputSchema({
    required int version,
    required List<PresetInputField> fields,
    PresetInputPresentation? presentation,
    @Default(<String, Object?>{}) Map<String, Object?> extensions,
  }) = _PresetInputSchema;
}

@freezed
sealed class PresetInputPresentation with _$PresetInputPresentation {
  const factory PresetInputPresentation({
    String? layout,
    String? primaryField,
    @Default(<String, Object?>{}) Map<String, Object?> extensions,
  }) = _PresetInputPresentation;
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
    num? maximum,
    int? maximumItems,
    String? defaultValue,
    @Default(<PresetInputFieldOption>[]) List<PresetInputFieldOption> options,
    PresetInputVisibleWhen? visibleWhen,
    @Default(<String, Object?>{}) Map<String, Object?> extensions,
  }) = _PresetInputField;
}

@freezed
sealed class PresetInputFieldOption with _$PresetInputFieldOption {
  const factory PresetInputFieldOption({
    required String value,
    required String label,
    String? description,
    String? iconKey,
    @Default(<String>[]) List<String> requiresFields,
    @Default(<String, Object?>{}) Map<String, Object?> extensions,
  }) = _PresetInputFieldOption;
}

@freezed
sealed class PresetInputVisibleWhen with _$PresetInputVisibleWhen {
  const factory PresetInputVisibleWhen({
    required String field,
    required List<String> equalsAny,
    @Default(<String, Object?>{}) Map<String, Object?> extensions,
  }) = _PresetInputVisibleWhen;
}

@freezed
sealed class CandidateSeed with _$CandidateSeed {
  const factory CandidateSeed({
    required String label,
    String? url,
  }) = _CandidateSeed;
}
