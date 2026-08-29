import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class AppStatus extends StatelessWidget {
  const AppStatus.loading({super.key})
    : loading = true,
      message = null,
      correlationId = null;

  const AppStatus.error({required this.message, this.correlationId, super.key})
    : loading = false;

  final bool loading;
  final String? message;
  final String? correlationId;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    if (loading) {
      return const AppScreenLoader();
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            liveRegion: true,
            label: message,
            child: Text(
              message ?? '',
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.foreground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (correlationId != null) ...[
            SizedBox(height: context.spaceSmall),
            Text(
              correlationId!,
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
