import 'package:flutter/widgets.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/review_screen.dart'
    as linkedin;
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/result_screen.dart'
    as linkedin;
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/execution_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/receipt_workflow_metadata.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/result_screen.dart'
    as receipt;
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/execution_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/review_screen.dart'
    as smart;
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/result_screen.dart'
    as smart;

Widget? configureRunScreenForPreset(String presetKey) {
  if (isReceiptWorkflowKey(presetKey)) {
    return const ReceiptConfigureRunScreen();
  }
  switch (presetKey) {
    case DailyLinkedInAiPostPreset.key:
      return const ConfigureRunScreen();
    case SmartPurchaseDecisionPreset.key:
      return const SmartPurchaseConfigureRunScreen();
    default:
      return null;
  }
}

Widget reviewScreenForPreset(String presetKey) =>
    isReceiptWorkflowKey(presetKey)
    ? const receipt.ReceiptResultScreen()
    : presetKey == SmartPurchaseDecisionPreset.key
    ? const smart.SmartPurchaseReviewScreen()
    : const linkedin.ReviewScreen();

Widget resultScreenForPreset(String presetKey) =>
    isReceiptWorkflowKey(presetKey)
    ? const receipt.ReceiptResultScreen()
    : presetKey == SmartPurchaseDecisionPreset.key
    ? const smart.SmartPurchaseResultScreen()
    : const linkedin.ResultScreen();

Widget? executionScreenForPreset(String presetKey) =>
    isReceiptWorkflowKey(presetKey)
    ? const ReceiptExecutionScreen()
    : presetKey == SmartPurchaseDecisionPreset.key
    ? const SmartPurchaseExecutionScreen()
    : null;
