import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';

export 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart'
    show
        receiptPresetKeys,
        legacyReceiptPresetKeys,
        isReceiptWorkflowKey,
        isLegacyReceiptPresetKey,
        resolveReceiptWorkflowStart,
        ReceiptWorkflowStart;

const receiptReportWriterAgentKey = 'receipt-report-writer';

String receiptSourceRange(String tabTitle, String range) {
  final trimmedRange = range.trim();
  if (trimmedRange.contains('!')) return trimmedRange;
  final escapedTitle = tabTitle.trim().replaceAll("'", "''");
  return "'$escapedTitle'!$trimmedRange";
}

String receiptColumnMappingJson(Map<String, String> mapping) {
  return jsonEncode({
    'date': mapping['date']?.trim(),
    'amount': mapping['amount']?.trim(),
    'category': mapping['category']?.trim(),
    'merchant': mapping['merchant']?.trim(),
  });
}

String receiptModeLabel(PresetInputSchema? schema, String analysisMode) {
  return schema?.analysisModeOption(analysisMode)?.label ??
      humanizePresetToken(analysisMode);
}

String receiptModeShortTitle(PresetInputSchema? schema, String analysisMode) {
  return receiptModeLabel(schema, analysisMode);
}

IconData receiptAnalysisModeIcon(String? iconKey) {
  return switch (iconKey) {
    'calendar-month' => LucideIcons.calendar,
    'wallet' => LucideIcons.wallet,
    'receipt-tax' => LucideIcons.receipt,
    'chart-trend' => LucideIcons.trendingUp,
    'tag' => LucideIcons.tag,
    'alert-circle' => LucideIcons.circleAlert,
    'piggy-bank' => LucideIcons.piggyBank,
    _ => LucideIcons.chartColumn,
  };
}

Set<String> receiptInactiveInputKeys({
  required PresetInputSchema schema,
  required Map<String, String> inputs,
}) {
  const conditionalKeys = {'budget', 'taxRate', 'category'};
  final active = schema.activeRequiresFields(inputs);
  return conditionalKeys.difference(active);
}
