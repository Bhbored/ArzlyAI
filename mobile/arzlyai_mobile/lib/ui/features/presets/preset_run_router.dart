import 'package:flutter/widgets.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/preset_key.dart';

Widget? configureRunScreenForPreset(String presetKey) {
  switch (presetKey) {
    case DailyLinkedInAiPostPreset.key:
      return const ConfigureRunScreen();
    default:
      return null;
  }
}
