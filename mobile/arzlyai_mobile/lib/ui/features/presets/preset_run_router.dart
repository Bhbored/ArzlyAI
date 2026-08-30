import 'package:flutter/widgets.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/review_screen.dart' as linkedin;
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/result_screen.dart' as linkedin;
import 'package:arzlyai_mobile/ui/features/presets/configure/dynamic_preset_configure_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/execution_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/review_screen.dart' as smart;
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/result_screen.dart' as smart;

Widget? configureRunScreenForPreset(String presetKey) {
  switch (presetKey) {
    case DailyLinkedInAiPostPreset.key:
      return const ConfigureRunScreen();
    case SmartPurchaseDecisionPreset.key:
      return const DynamicPresetConfigureScreen();
    default:
      return null;
  }
}

Widget reviewScreenForPreset(String presetKey) =>
    presetKey == SmartPurchaseDecisionPreset.key
        ? const smart.SmartPurchaseReviewScreen()
        : const linkedin.ReviewScreen();

Widget resultScreenForPreset(String presetKey) =>
    presetKey == SmartPurchaseDecisionPreset.key
        ? const smart.SmartPurchaseResultScreen()
        : const linkedin.ResultScreen();

Widget? executionScreenForPreset(String presetKey) =>
    presetKey == SmartPurchaseDecisionPreset.key
        ? const SmartPurchaseExecutionScreen()
        : null;
