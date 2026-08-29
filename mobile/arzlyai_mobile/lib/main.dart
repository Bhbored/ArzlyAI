import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arzlyai_mobile/core/network/dev_ssl.dart';
import 'package:arzlyai_mobile/core/themes/theme_mode_provider.dart';
import 'package:arzlyai_mobile/core/themes/theme_selector.dart';
import 'package:arzlyai_mobile/ui/features/presets/catalog/preset_catalog_screen.dart';
import 'package:arzlyai_mobile/ui/scheduling/notification_navigation.dart';

const _languageKey = 'language';

Locale _localeFromCode(String? language) {
  return switch (language?.trim().toLowerCase()) {
    'ar' => const Locale('ar'),
    _ => const Locale('en'),
  };
}

Future<Locale> _prepareLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final locale = _localeFromCode(prefs.getString(_languageKey));
  await prefs.setString('locale', locale.languageCode);
  return locale;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    DevSslHttpOverrides.enableIfDebug();
  }
  final startLocale = await _prepareLocale();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: startLocale,
        saveLocale: true,
        useOnlyLangCode: true,
        useFallbackTranslations: true,
        child: const ArzlyAiApp(),
      ),
    ),
  );
}

class ArzlyAiApp extends ConsumerWidget {
  const ArzlyAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);

    return ShadApp.custom(
      themeMode: themeModeAsync.value ?? ThemeMode.system,
      darkTheme: ThemeSelector.shadDark,
      theme: ThemeSelector.shadLight,
      appBuilder: (context) {
        final baseTheme = Theme.of(context);
        return MaterialApp(
          navigatorKey: rootNavigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'ArzlyAI',
          theme: baseTheme.copyWith(
            appBarTheme: AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              backgroundColor: baseTheme.colorScheme.surface,
              foregroundColor: baseTheme.colorScheme.onSurface,
              iconTheme: IconThemeData(color: baseTheme.colorScheme.onSurface),
              titleTextStyle:
                  (baseTheme.appBarTheme.titleTextStyle ??
                          baseTheme.textTheme.titleLarge)
                      ?.copyWith(color: baseTheme.colorScheme.onSurface),
            ),
          ),
          localizationsDelegates: [
            ...context.localizationDelegates,
            GlobalShadLocalizations.delegate,
          ],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) => ShadAppBuilder(
            child: SafeArea(
              top: false,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
          home: const AppSchedulingShell(child: PresetCatalogScreen()),
        );
      },
    );
  }
}
