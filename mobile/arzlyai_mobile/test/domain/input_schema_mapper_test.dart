import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/preset_input_field_type.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/input_schema_mapper.dart';

void main() {
  const mapper = InputSchemaMapper();

  test('fromJsonString parses receipt schema v2 selectCards and visibleWhen', () {
    final json = File(
      'test/presets/receipt_workflows/fixtures/receipt_intelligence_schema_v2.json',
    ).readAsStringSync();
    final schema = mapper.fromJsonString(json);

    expect(schema, isNotNull);
    expect(schema!.version, 2);
    expect(schema.presentation?.primaryField, 'analysisMode');
    expect(schema.analysisModeField?.type, PresetInputFieldType.selectCards);
    expect(schema.analysisModeOptions, hasLength(7));
    expect(schema.analysisModeOptions.first.iconKey, 'calendar-month');
    expect(
      schema.fieldForKey('budget')?.visibleWhen?.equalsAny,
      ['weekly-budget', 'savings-tracker'],
    );
    expect(schema.fieldForKey('deliveryMode')?.type, PresetInputFieldType.select);
    expect(schema.fieldForKey('recipientEmail')?.type, PresetInputFieldType.email);
  });

  test('fromJson preserves unknown root properties', () {
    final schema = mapper.fromJson({
      'version': 2,
      'futureFlag': true,
      'fields': const [],
    });
    expect(schema.extensions['futureFlag'], isTrue);
  });
}
