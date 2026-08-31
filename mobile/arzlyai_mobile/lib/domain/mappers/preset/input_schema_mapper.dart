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
      presentation: _presentation(json['presentation']),
      extensions: _unknownRootProperties(json),
    );
  }

  Map<String, Object?> _unknownRootProperties(Map<String, dynamic> json) {
    const known = {'version', 'fields', 'presentation'};
    return {
      for (final entry in json.entries)
        if (!known.contains(entry.key)) entry.key: entry.value,
    };
  }

  PresetInputPresentation? _presentation(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    const known = {'layout', 'primaryField'};
    return PresetInputPresentation(
      layout: raw['layout'] as String?,
      primaryField: raw['primaryField'] as String?,
      extensions: {
        for (final entry in raw.entries)
          if (!known.contains(entry.key)) entry.key: entry.value,
      },
    );
  }

  PresetInputField _field(Map<String, dynamic> json) {
    const known = {
      'key',
      'label',
      'type',
      'required',
      'maxLength',
      'minimum',
      'maximum',
      'maximumItems',
      'defaultValue',
      'options',
      'visibleWhen',
    };
    return PresetInputField(
      key: json['key'] as String,
      label: json['label'] as String? ?? json['key'] as String,
      type: PresetInputFieldType.parse(json['type'] as String?),
      required: json['required'] as bool? ?? false,
      maxLength: json['maxLength'] as int?,
      minimum: json['minimum'] as num?,
      maximum: json['maximum'] as num?,
      maximumItems: json['maximumItems'] as int?,
      defaultValue: json['defaultValue'] as String?,
      options: _options(json['options']),
      visibleWhen: _visibleWhen(json['visibleWhen']),
      extensions: {
        for (final entry in json.entries)
          if (!known.contains(entry.key)) entry.key: entry.value,
      },
    );
  }

  List<PresetInputFieldOption> _options(Object? raw) {
    if (raw is! List<dynamic>) return const [];
    return raw
        .cast<Map<String, dynamic>>()
        .map(_option)
        .toList(growable: false);
  }

  PresetInputFieldOption _option(Map<String, dynamic> json) {
    const known = {
      'value',
      'label',
      'description',
      'iconKey',
      'requiresFields',
    };
    final requires = json['requiresFields'];
    return PresetInputFieldOption(
      value: json['value'] as String,
      label: json['label'] as String? ?? json['value'] as String,
      description: json['description'] as String?,
      iconKey: json['iconKey'] as String?,
      requiresFields: requires is List<dynamic>
          ? requires.cast<String>()
          : const [],
      extensions: {
        for (final entry in json.entries)
          if (!known.contains(entry.key)) entry.key: entry.value,
      },
    );
  }

  PresetInputVisibleWhen? _visibleWhen(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final equalsAny = raw['equalsAny'];
    return PresetInputVisibleWhen(
      field: raw['field'] as String,
      equalsAny: equalsAny is List<dynamic>
          ? equalsAny.cast<String>()
          : const [],
      extensions: {
        for (final entry in raw.entries)
          if (entry.key != 'field' && entry.key != 'equalsAny')
            entry.key: entry.value,
      },
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
