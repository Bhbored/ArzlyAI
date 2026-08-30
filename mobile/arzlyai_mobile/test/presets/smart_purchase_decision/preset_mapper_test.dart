import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/preset_input_field_type.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';

Map<String, dynamic> _fixture(String name) {
  return jsonDecode(
        File('test/presets/smart_purchase_decision/fixtures/$name')
            .readAsStringSync(),
      )
      as Map<String, dynamic>;
}

void main() {
  test('SmartPurchasePresetMapper_WhenLoaded_ParsesSchemasAndGraph', () {
    final details = const PresetMapper().detailsFromDto(
      PresetDetailsResponse.fromJson(_fixture('preset_details.json')),
    );

    expect(details.key, 'smart-purchase-decision');
    expect(details.name, 'Smart Buy');
    expect(details.resultContract?.version, 4);
    expect(details.inputSchema?.fields.length, 5);
    expect(
      details.inputSchema?.fields.first.type,
      PresetInputFieldType.multilineText,
    );
    expect(details.integrations, isEmpty);

    final confirm = details.workflow.nodes
        .where((node) => node.key == 'confirm-request')
        .single;
    expect(confirm.approvalConfiguration?.acceptLabel, 'Confirm');
    expect(confirm.approvalConfiguration?.editLabel, "That's not quite right");

    final review = details.workflow.nodes
        .where((node) => node.key == 'review-pick')
        .single;
    expect(review.resultContract?.version, 4);
    expect(review.approvalConfiguration?.acceptLabel, 'Looks good');
  });
}
