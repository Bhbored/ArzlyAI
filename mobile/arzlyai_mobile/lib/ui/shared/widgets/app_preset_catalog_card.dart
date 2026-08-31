import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';

class AppPresetCatalogCard extends StatelessWidget {
  const AppPresetCatalogCard({
    required this.presetKey,
    required this.name,
    required this.description,
    required this.onOpen,
    super.key,
  });

  final String presetKey;
  final String name;
  final String description;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final cardForeground = theme.colorScheme.cardForeground;

    return ShadCard(
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingMedium,
        vertical: context.paddingSmall,
      ),
      child: ShadTheme.merge(
        data: ShadThemeData(
          colorScheme: theme.colorScheme.copyWith(foreground: cardForeground),
        ),
        child: ShadAccordion<String>(
          children: [
            ShadAccordionItem(
              value: presetKey,
              title: Text(name),
              titleStyle: theme.textTheme.h4.copyWith(
                color: cardForeground,
                fontWeight: FontWeight.w600,
              ),
              separator: const SizedBox.shrink(),
              padding: EdgeInsets.symmetric(vertical: context.spaceSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    description,
                    style: theme.textTheme.muted.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                  SizedBox(height: context.spaceMedium),
                  AppButton.primary(label: 'Open preset', onPressed: onOpen),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
