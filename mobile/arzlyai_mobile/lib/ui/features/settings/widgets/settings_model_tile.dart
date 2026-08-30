import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/model_tool_catalog.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';

class SettingsModelTile extends StatefulWidget {
  const SettingsModelTile({
    required this.model,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final ProviderModel model;
  final bool selected;
  final VoidCallback onSelect;

  @override
  State<SettingsModelTile> createState() => _SettingsModelTileState();
}

class _SettingsModelTileState extends State<SettingsModelTile> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final tools = modelToolDescriptors(widget.model);
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingMedium,
                vertical: context.paddingSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.displayName,
                          style: theme.textTheme.p.copyWith(
                            color: theme.colorScheme.cardForeground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.spaceSmall / 4),
                        Text(
                          modelToolSummary(widget.model),
                          style: theme.textTheme.muted.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.selected)
                    Padding(
                      padding: EdgeInsets.only(right: context.spaceSmall / 2),
                      child: Icon(
                        LucideIcons.check,
                        size: context.iconSmall,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  Icon(
                    _expanded
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: context.iconSmall,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(
                context.paddingMedium,
                0,
                context.paddingMedium,
                context.paddingSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: context.spaceSmall / 2,
                    runSpacing: context.spaceSmall / 2,
                    children: [
                      for (final tool in tools)
                        _ModelToolChip(tool: tool),
                    ],
                  ),
                  if (!widget.selected) ...[
                    SizedBox(height: context.spaceSmall),
                    AppButton.primary(
                      label: 'Set as default',
                      onPressed: widget.onSelect,
                    ),
                  ],
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

class _ModelToolChip extends StatelessWidget {
  const _ModelToolChip({required this.tool});

  final ModelToolDescriptor tool;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final tint = tool.supported
        ? theme.colorScheme.primary
        : theme.colorScheme.mutedForeground;
    return Tooltip(
      message: tool.description,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingSmall,
          vertical: context.spaceSmall / 2,
        ),
        decoration: BoxDecoration(
          color: tool.supported
              ? tint.withValues(alpha: 0.1)
              : theme.colorScheme.muted.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(context.borderRadiusMedium),
          border: Border.all(
            color: tool.supported
                ? tint.withValues(alpha: 0.45)
                : theme.colorScheme.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tool.supported ? tool.icon : LucideIcons.circleOff,
              size: context.iconSmall * 0.85,
              color: tint,
            ),
            SizedBox(width: context.spaceSmall / 3),
            Text(
              tool.label,
              style: theme.textTheme.small.copyWith(
                color: tool.supported
                    ? theme.colorScheme.cardForeground
                    : theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
