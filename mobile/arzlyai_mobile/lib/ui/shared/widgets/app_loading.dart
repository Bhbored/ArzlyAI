import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({this.small = false, super.key});

  final bool small;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final primary = theme.colorScheme.primary;
    final size = small ? context.loadingIndicatorSmall : context.loadingIndicatorMedium;
    final strokeWidth = small ? context.loadingStrokeWidth : context.loadingStrokeWidthBold;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.45),
            blurRadius: context.glowBlurMedium,
            spreadRadius: context.glowSpreadSmall,
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: primary,
        ),
      ),
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    required this.visible,
    required this.child,
    super.key,
  });

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;
    final theme = ShadTheme.of(context);
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ColoredBox(
            color: theme.colorScheme.background.withValues(alpha: 0.72),
            child: const Center(child: AppLoadingIndicator()),
          ),
        ),
      ],
    );
  }
}

class AppScreenLoader extends StatelessWidget {
  const AppScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoadingIndicator());
  }
}
