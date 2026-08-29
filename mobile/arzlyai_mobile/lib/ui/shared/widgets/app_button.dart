import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum AppButtonVariant { primary, destructive, ghost }

class AppButton extends StatelessWidget {
  const AppButton._({
    required this.variant,
    required this.label,
    this.onPressed,
    super.key,
  });

  factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    Key? key,
  }) {
    return AppButton._(
      variant: AppButtonVariant.primary,
      label: label,
      onPressed: onPressed,
      key: key,
    );
  }

  factory AppButton.destructive({
    required String label,
    VoidCallback? onPressed,
    Key? key,
  }) {
    return AppButton._(
      variant: AppButtonVariant.destructive,
      label: label,
      onPressed: onPressed,
      key: key,
    );
  }

  factory AppButton.ghost({
    required String label,
    VoidCallback? onPressed,
    Key? key,
  }) {
    return AppButton._(
      variant: AppButtonVariant.ghost,
      label: label,
      onPressed: onPressed,
      key: key,
    );
  }

  final AppButtonVariant variant;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final child = Text(label);
    return switch (variant) {
      AppButtonVariant.primary => ShadButton(
        onPressed: onPressed,
        child: child,
      ),
      AppButtonVariant.destructive => ShadButton.destructive(
        onPressed: onPressed,
        child: child,
      ),
      AppButtonVariant.ghost => ShadButton.ghost(
        onPressed: onPressed,
        child: child,
      ),
    };
  }
}
