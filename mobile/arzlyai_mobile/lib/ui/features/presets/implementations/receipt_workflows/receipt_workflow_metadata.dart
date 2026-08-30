import 'dart:convert';

import 'package:flutter/foundation.dart';

export 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart'
    show receiptPresetKeys, isReceiptWorkflowKey;

const receiptReportWriterAgentKey = 'receipt-report-writer';

@immutable
class ReceiptWorkflowMetadata {
  const ReceiptWorkflowMetadata({
    required this.key,
    required this.title,
    required this.shortTitle,
    required this.mode,
    required this.description,
    this.requiresBudget = false,
    this.requiresTaxRate = false,
    this.requiresCategory = false,
  });

  final String key;
  final String title;
  final String shortTitle;
  final String mode;
  final String description;
  final bool requiresBudget;
  final bool requiresTaxRate;
  final bool requiresCategory;
}

const receiptWorkflowMetadata = <ReceiptWorkflowMetadata>[
  ReceiptWorkflowMetadata(
    key: 'receipt-monthly-spending',
    title: 'Monthly Receipt Spending',
    shortTitle: 'Monthly spending',
    mode: 'monthly-spending',
    description: 'Summarize this month by category and merchant.',
  ),
  ReceiptWorkflowMetadata(
    key: 'receipt-weekly-budget',
    title: 'Weekly Receipt Budget',
    shortTitle: 'Weekly budget',
    mode: 'weekly-budget',
    description: 'Compare this week’s receipt spending with a budget.',
    requiresBudget: true,
  ),
  ReceiptWorkflowMetadata(
    key: 'receipt-quarterly-tax',
    title: 'Quarterly Receipt Tax',
    shortTitle: 'Quarterly tax',
    mode: 'quarterly-tax',
    description: 'Estimate tax from this quarter’s receipt spending.',
    requiresTaxRate: true,
  ),
  ReceiptWorkflowMetadata(
    key: 'receipt-yearly-review',
    title: 'Yearly Receipt Review',
    shortTitle: 'Yearly review',
    mode: 'yearly-review',
    description: 'Review receipt spending trends across the year.',
  ),
  ReceiptWorkflowMetadata(
    key: 'receipt-category-dive',
    title: 'Receipt Category Dive',
    shortTitle: 'Category dive',
    mode: 'category-dive',
    description: 'Analyze receipt spending for one category.',
    requiresCategory: true,
  ),
  ReceiptWorkflowMetadata(
    key: 'receipt-anomaly-detector',
    title: 'Receipt Anomaly Detector',
    shortTitle: 'Anomaly detector',
    mode: 'anomaly-detector',
    description: 'Highlight statistically unusual receipt amounts.',
  ),
  ReceiptWorkflowMetadata(
    key: 'receipt-savings-tracker',
    title: 'Receipt Savings Tracker',
    shortTitle: 'Savings tracker',
    mode: 'savings-tracker',
    description: 'Track spending against a monthly savings target.',
    requiresBudget: true,
  ),
];

ReceiptWorkflowMetadata? receiptMetadataForKey(String key) {
  return receiptWorkflowMetadata
      .where((metadata) => metadata.key == key)
      .firstOrNull;
}

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
