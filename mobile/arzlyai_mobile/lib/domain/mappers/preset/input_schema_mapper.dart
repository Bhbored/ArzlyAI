import 'dart:convert';

import 'package:arzlyai_mobile/core/enums/preset_input_field_type.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';

class InputSchemaMapper {
  const InputSchemaMapper();

  PresetInputSchema? fromJsonString(String? json) {
    if (json == null || json.trim().isEmpty) return null;
    final root = jsonDecode(json) as Map<String, dynamic>;
    return fromJson(root);
  }

  PresetInputSchema fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'] as List<dynamic>? ?? const [];
    return PresetInputSchema(
      version: json['version'] as int? ?? 1,
      fields: rawFields
          .cast<Map<String, dynamic>>()
          .map(_field)
          .toList(growable: false),
    );
  }

  PresetInputField _field(Map<String, dynamic> json) {
    return PresetInputField(
      key: json['key'] as String,
      label: json['label'] as String? ?? json['key'] as String,
      type: PresetInputFieldType.parse(json['type'] as String?),
      required: json['required'] as bool? ?? false,
      maxLength: json['maxLength'] as int?,
      minimum: json['minimum'] as num?,
      maximumItems: json['maximumItems'] as int?,
    );
  }

  String encodeCandidateSeeds(List<CandidateSeed> seeds) {
    return jsonEncode(
      seeds
          .map(
            (seed) => {
              'label': seed.label,
              'url': seed.url,
            },
          )
          .toList(),
    );
  }
}
