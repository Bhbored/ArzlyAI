import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum AppCardVariant { standard, interactive }

class AppCard extends StatelessWidget {
  const AppCard._({
    required this.variant,
    this.title,
    this.onPressed,
    required this.child,
    super.key,
  });

  factory AppCard.standard({String? title, Key? key, required Widget child}) {
    return AppCard._(
      variant: AppCardVariant.standard,
      title: title,
      key: key,
      child: child,
    );
  }

  factory AppCard.interactive({
    String? title,
    VoidCallback? onPressed,
    Key? key,
    required Widget child,
  }) {
    return AppCard._(
      variant: AppCardVariant.interactive,
      title: title,
      onPressed: onPressed,
      key: key,
      child: child,
    );
  }

  final AppCardVariant variant;
  final Widget child;
  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final cardForeground = theme.colorScheme.cardForeground;
    final card = ShadCard(
      title: title == null
          ? null
          : Text(
              title!,
              style: theme.textTheme.h4.copyWith(color: cardForeground),
            ),
      child: ShadTheme.merge(
        data: ShadThemeData(
          colorScheme: theme.colorScheme.copyWith(foreground: cardForeground),
        ),
        child: DefaultTextStyle(
          style: theme.textTheme.p.copyWith(color: cardForeground),
          child: child,
        ),
      ),
    );
    if (variant == AppCardVariant.interactive) {
      return GestureDetector(onTap: onPressed, child: card);
    }
    return card;
  }
}
