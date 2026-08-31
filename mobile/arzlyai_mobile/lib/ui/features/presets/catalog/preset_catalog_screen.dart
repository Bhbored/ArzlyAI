import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_preset_key_provider.dart';
import 'package:arzlyai_mobile/ui/features/presets/details/preset_details_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_screen.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_preset_catalog_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class PresetCatalogScreen extends ConsumerWidget {
  const PresetCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(presetCatalogProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text('Presets', style: theme.textTheme.h4),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: catalog.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text('No presets', style: theme.textTheme.p));
          }
          return ListView.separated(
            padding: EdgeInsets.all(context.paddingMedium),
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(height: context.spaceSmall),
            itemBuilder: (context, index) {
              final item = items[index];
              return AppPresetCatalogCard(
                presetKey: item.key,
                name: item.name,
                description: item.description,
                onOpen: () {
                  ref.read(selectedPresetKeyProvider.notifier).update(item.key);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PresetDetailsScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) {
          final message = error is ApiException ? error.userMessage : '$error';
          final correlation = error is ApiException
              ? error.correlationId
              : null;
          return Column(
            children: [
              Expanded(
                child: AppStatus.error(
                  message: message,
                  correlationId: correlation,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(context.paddingMedium),
                child: AppButton.primary(
                  label: 'Retry',
                  onPressed: () =>
                      ref.read(presetCatalogProvider.notifier).refresh(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
