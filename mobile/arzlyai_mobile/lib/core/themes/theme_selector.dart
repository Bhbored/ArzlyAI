import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'app_colors.dart';

class ThemeSelector {
  static ShadThemeData get shadDark => ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadGreenColorScheme.dark().copyWith(
      background: AppColors.background,
      foreground: AppColors.foreground,
      primary: AppColors.primary,
      primaryForeground: AppColors.primaryForeground,
      secondary: AppColors.secondary,
      secondaryForeground: AppColors.secondaryForeground,
      muted: AppColors.muted,
      mutedForeground: AppColors.mutedForeground,
      accent: AppColors.accent,
      accentForeground: AppColors.accentForeground,
      destructive: AppColors.destructive,
      destructiveForeground: AppColors.destructiveForeground,
      border: AppColors.border,
      input: AppColors.input,
      card: AppColors.card,
      cardForeground: AppColors.foreground,
      popover: AppColors.popover,
      popoverForeground: AppColors.popoverForeground,
    ),
    textTheme: ShadTextTheme(family: GoogleFonts.jetBrainsMono().fontFamily),
  );

  static ShadThemeData get shadLight => ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadGreenColorScheme.light().copyWith(
      background: AppColors.backgroundLight,
      foreground: AppColors.foreground,
      primary: AppColors.primaryLight,
      primaryForeground: AppColors.primaryForegroundLight,
      secondary: AppColors.secondaryLight,
      secondaryForeground: AppColors.secondaryForegroundLight,
      muted: AppColors.mutedLight,
      mutedForeground: AppColors.mutedForegroundLight,
      accent: AppColors.accentLight,
      accentForeground: AppColors.accentForegroundLight,
      destructive: AppColors.destructiveLight,
      border: AppColors.borderLight,
      input: AppColors.inputLight,
      card: AppColors.cardLight,
      cardForeground: AppColors.foregroundLight,
      popover: AppColors.popoverLight,
      popoverForeground: AppColors.popoverForegroundLight,
    ),
    textTheme: ShadTextTheme(family: GoogleFonts.jetBrainsMono().fontFamily),
  );
}
