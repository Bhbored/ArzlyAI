import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';

abstract final class ReceiptIntelligencePreset {
  static const key = 'receipt-intelligence';
}

const legacyReceiptPresetKeys = <String>{
  'receipt-monthly-spending',
  'receipt-weekly-budget',
  'receipt-quarterly-tax',
  'receipt-yearly-review',
  'receipt-category-dive',
  'receipt-anomaly-detector',
  'receipt-savings-tracker',
};

const receiptPresetKeys = <String>{
  ReceiptIntelligencePreset.key,
  ...legacyReceiptPresetKeys,
};

const legacyReceiptPresetToAnalysisMode = <String, String>{
  'receipt-monthly-spending': 'monthly-spending',
  'receipt-weekly-budget': 'weekly-budget',
  'receipt-quarterly-tax': 'quarterly-tax',
  'receipt-yearly-review': 'yearly-review',
  'receipt-category-dive': 'category-dive',
  'receipt-anomaly-detector': 'anomaly-detector',
  'receipt-savings-tracker': 'savings-tracker',
};

bool isLegacyReceiptPresetKey(String key) =>
    legacyReceiptPresetKeys.contains(key);

bool isReceiptWorkflowKey(String key) => receiptPresetKeys.contains(key);

String canonicalReceiptPresetKey(String key) =>
    isReceiptWorkflowKey(key) ? ReceiptIntelligencePreset.key : key;

class ReceiptWorkflowStart {
  const ReceiptWorkflowStart({
    required this.presetKey,
    required this.inputs,
  });

  final String presetKey;
  final Map<String, String> inputs;
}

ReceiptWorkflowStart? resolveReceiptWorkflowStart({
  required String presetKey,
  required Map<String, String> inputs,
}) {
  if (!isReceiptWorkflowKey(presetKey)) return null;
  final resolved = Map<String, String>.from(inputs);
  final analysisMode = resolved['analysisMode']?.trim() ?? '';
  if (analysisMode.isEmpty) {
    if (isLegacyReceiptPresetKey(presetKey)) {
      final mode = legacyReceiptPresetToAnalysisMode[presetKey];
      if (mode == null) return null;
      resolved['analysisMode'] = mode;
    } else {
      return null;
    }
  }
  return ReceiptWorkflowStart(
    presetKey: ReceiptIntelligencePreset.key,
    inputs: resolved,
  );
}

Object receiptSafeError(Object error) {
  const message = 'Receipt workflow request failed.';
  if (error is ApiException) {
    return ApiException(
      userMessage: message,
      error: message,
      statusCode: error.statusCode,
      correlationId: error.correlationId,
      retryAfter: error.retryAfter,
      originalError: null,
    );
  }
  return StateError(message);
}
