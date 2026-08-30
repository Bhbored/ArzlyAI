import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';

class SettingsGroupedList extends StatelessWidget {
  const SettingsGroupedList({
    required this.children,
    this.dividerIndent,
    super.key,
  });

  final List<Widget> children;
  final double? dividerIndent;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(context.borderRadiusLarge),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _withDividers(context, children, dividerIndent),
      ),
    );
  }

  static List<Widget> _withDividers(
    BuildContext context,
    List<Widget> items,
    double? dividerIndent,
  ) {
    if (items.isEmpty) return const [];
    final theme = ShadTheme.of(context);
    final indent = dividerIndent ?? context.paddingMedium;
    final output = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      output.add(items[i]);
      if (i < items.length - 1) {
        output.add(
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.border,
            indent: indent,
          ),
        );
      }
    }
    return output;
  }
}

class SettingsListRow extends StatelessWidget {
  const SettingsListRow({
    required this.title,
    required this.onTap,
    this.leading,
    this.subtitle,
    this.trailing,
    this.selected = false,
    this.showChevron = true,
    super.key,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool selected;
  final bool showChevron;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.borderRadiusLarge),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingMedium,
            vertical: context.paddingSmall,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: context.spaceSmall),
              ],
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
                    if (subtitle != null) ...[
                      SizedBox(height: context.spaceSmall / 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.muted.copyWith(
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                trailing!,
                SizedBox(width: context.spaceSmall / 2),
              ],
              if (selected)
                Icon(
                  LucideIcons.check,
                  size: context.iconSmall,
                  color: theme.colorScheme.primary,
                )
              else if (showChevron)
                Icon(
                  LucideIcons.chevronRight,
                  size: context.iconSmall,
                  color: theme.colorScheme.mutedForeground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
