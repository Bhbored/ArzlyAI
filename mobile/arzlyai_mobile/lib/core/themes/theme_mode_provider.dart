import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/storage/shared_preferences/shared_preferences.dart';

part 'theme_mode_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async {
    final prefs = ref.read(sharedPreferencesHandlerProvider);
    return prefs.getTheme();
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesHandlerProvider);
    await prefs.setTheme(mode);
    state = AsyncData(mode);
  }
}
