import 'package:flutter/widgets.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/execution_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/review_screen.dart'
    as brain_dump;
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/result_screen.dart'
    as brain_dump;
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/review_screen.dart'
    as linkedin;
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/result_screen.dart'
    as linkedin;
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/execution_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/review_screen.dart'
    as smart;
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/result_screen.dart'
    as smart;

Widget? configureRunScreenForPreset(String presetKey) {
  switch (presetKey) {
    case DailyLinkedInAiPostPreset.key:
      return const ConfigureRunScreen();
    case SmartPurchaseDecisionPreset.key:
      return const SmartPurchaseConfigureRunScreen();
    case BrainDumpToActionPreset.key:
      return const BrainDumpConfigureRunScreen();
    default:
      return null;
  }
}

Widget reviewScreenForPreset(String presetKey) {
  switch (presetKey) {
    case SmartPurchaseDecisionPreset.key:
      return const smart.SmartPurchaseReviewScreen();
    case BrainDumpToActionPreset.key:
      return const brain_dump.BrainDumpReviewScreen();
    default:
      return const linkedin.ReviewScreen();
  }
}

Widget resultScreenForPreset(String presetKey) {
  switch (presetKey) {
    case SmartPurchaseDecisionPreset.key:
      return const smart.SmartPurchaseResultScreen();
    case BrainDumpToActionPreset.key:
      return const brain_dump.BrainDumpResultScreen();
    default:
      return const linkedin.ResultScreen();
  }
}

Widget? executionScreenForPreset(String presetKey) {
  switch (presetKey) {
    case SmartPurchaseDecisionPreset.key:
      return const SmartPurchaseExecutionScreen();
    case BrainDumpToActionPreset.key:
      return const BrainDumpExecutionScreen();
    default:
      return null;
  }
}
