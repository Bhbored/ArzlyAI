import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class SettingsNavTile extends StatelessWidget {
  const SettingsNavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final tint = iconColor ?? theme.colorScheme.primary;
    return Padding(
      padding: EdgeInsets.only(bottom: context.spaceSmall),
      child: AppCard.interactive(
        onPressed: onTap,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(context.borderRadiusMedium),
                border: Border.all(color: tint.withValues(alpha: 0.28)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: tint, size: context.iconMedium),
            ),
            SizedBox(width: context.spaceSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.p.copyWith(
                      color: theme.colorScheme.cardForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.spaceSmall / 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.muted.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: context.iconSmall,
              color: theme.colorScheme.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}
