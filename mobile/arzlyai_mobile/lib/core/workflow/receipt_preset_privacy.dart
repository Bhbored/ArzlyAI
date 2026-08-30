import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';

const receiptPresetKeys = <String>{
  'receipt-monthly-spending',
  'receipt-weekly-budget',
  'receipt-quarterly-tax',
  'receipt-yearly-review',
  'receipt-category-dive',
  'receipt-anomaly-detector',
  'receipt-savings-tracker',
};

bool isReceiptWorkflowKey(String key) => receiptPresetKeys.contains(key);

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
