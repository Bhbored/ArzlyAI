import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/themes/theme_selector.dart';

Widget testApp({required Widget home}) {
  GoogleFonts.config.allowRuntimeFetching = false;
  return ShadApp.custom(
    darkTheme: ThemeSelector.shadDark,
    theme: ThemeSelector.shadLight,
    appBuilder: (context) {
      return MaterialApp(
        theme: Theme.of(context),
        builder: (context, child) => ShadAppBuilder(child: child!),
        home: home,
      );
    },
  );
}
