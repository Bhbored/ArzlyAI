import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/google/google_auth_provider.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_grouped_list.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsGoogleAccountScreen extends ConsumerWidget {
  const SettingsGoogleAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final auth = ref.watch(googleAuthProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Google account', style: theme.textTheme.h4),
      ),
      body: AppLoadingOverlay(
        visible: auth.isBusy,
        child: ListView(
          padding: EdgeInsets.all(context.paddingMedium),
          children: [
            Text(
              'One Google account powers Sheets, Gmail, Tasks, and Calendar. '
              'Authorize each service when you need it. Tokens stay on this device '
              'and are sent to the backend only inside encrypted envelopes.',
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            SizedBox(height: context.spaceMedium),
            AppCard.standard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      BrandIcon.connector(
                        ConnectorKeys.googleSheets,
                        size: context.iconLarge + 4,
                      ),
                      SizedBox(width: context.spaceSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.isSignedIn
                                  ? (auth.account?.email ??
                                        auth.account?.displayName ??
                                        'Signed in')
                                  : 'Not signed in',
                              style: theme.textTheme.small.copyWith(
                                color: theme.colorScheme.cardForeground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              auth.isSignedIn
                                  ? 'Account connected on this device'
                                  : 'Sign in to authorize Google services',
                              style: theme.textTheme.muted.copyWith(
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spaceSmall),
                  if (!auth.isSignedIn)
                    AppButton.primary(
                      label: auth.isBusy ? 'Signing in…' : 'Sign in with Google',
                      onPressed: auth.isBusy
                          ? null
                          : () => ref.read(googleAuthProvider.notifier).signIn(),
                    )
                  else
                    AppButton.destructive(
                      label: 'Disconnect Google account',
                      onPressed: auth.isBusy
                          ? null
                          : () => ref.read(googleAuthProvider.notifier).disconnect(),
                    ),
                ],
              ),
            ),
            if (auth.errorMessage != null) ...[
              SizedBox(height: context.spaceSmall),
              Text(
                auth.errorMessage!,
                style: theme.textTheme.muted.copyWith(
                  color: theme.colorScheme.destructive,
                ),
              ),
            ],
            SizedBox(height: context.spaceMedium),
            SettingsGroupedList(
              dividerIndent: context.paddingMedium + 40 + context.spaceSmall,
              children: [
                for (final connectorKey in ConnectorKeys.googleConnectors)
                  _ServiceRow(connectorKey: connectorKey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends ConsumerWidget {
  const _ServiceRow({required this.connectorKey});

  final String connectorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(googleAuthProvider);
    final authorized = auth.isConnectorAuthorized(connectorKey);
    return SettingsListRow(
      leading: BrandIcon.connector(connectorKey),
      title: connectorSettingsLabel(connectorKey),
      subtitle: auth.isSignedIn
          ? (authorized ? 'Authorized' : 'Not authorized')
          : 'Sign in first',
      trailing: auth.isSignedIn && !authorized
          ? AppButton.ghost(
              label: auth.isBusy ? '…' : 'Authorize',
              onPressed: auth.isBusy
                  ? null
                  : () => ref
                        .read(googleAuthProvider.notifier)
                        .authorizeService(connectorKey),
            )
          : null,
      showChevron: false,
      onTap: () {
        if (auth.isSignedIn && !authorized && !auth.isBusy) {
          ref.read(googleAuthProvider.notifier).authorizeService(connectorKey);
        }
      },
    );
  }
}
