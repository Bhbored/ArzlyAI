import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_connect_provider.dart';
import 'package:arzlyai_mobile/data/providers/connectors/linkedin_connector_status_provider.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class AppConnectorCard extends ConsumerWidget {
  const AppConnectorCard._({required this.connectorKey, super.key});

  factory AppConnectorCard.linkedin({Key? key}) {
    return AppConnectorCard._(connectorKey: ConnectorKeys.linkedin, key: key);
  }

  final String connectorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (connectorKey != ConnectorKeys.linkedin) {
      return const SizedBox.shrink();
    }

    final connected = ref.watch(linkedInConnectorStatusProvider);
    final connectState = ref.watch(connectorConnectProvider(connectorKey));
    final busy = connectState is AsyncLoading;
    final theme = ShadTheme.of(context);

    return AppLoadingOverlay(
      visible: busy,
      child: AppCard.standard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.linkedin,
                  size: context.iconLarge,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: context.spaceSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LinkedIn',
                        style: theme.textTheme.small.copyWith(
                          color: theme.colorScheme.cardForeground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      connected.when(
                        data: (value) => Text(
                          value ? 'Connected' : 'Not connected',
                          style: theme.textTheme.muted.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                        loading: () => Text(
                          'Checking connection…',
                          style: theme.textTheme.muted.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                        error: (_, _) => Text(
                          'Not connected',
                          style: theme.textTheme.muted.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spaceSmall),
            Text(
              'Authorize through LinkedIn in your browser. ArzlyAI uses Nango to broker OAuth — access tokens stay on your device.',
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            SizedBox(height: context.spaceSmall),
            _Actions(
              connectorKey: connectorKey,
              connected: connected.value ?? false,
              busy: busy,
            ),
            if (connectState.hasError)
              Padding(
                padding: EdgeInsets.only(top: context.spaceSmall),
                child: Text(
                  _connectorErrorMessage(connectState.error),
                  style: theme.textTheme.muted.copyWith(
                    color: theme.colorScheme.destructive,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _connectorErrorMessage(Object? error) {
    if (error is ApiException) return error.userMessage;
    if (error is StateError) return error.message;
    if (error is TimeoutException) {
      return 'Authorization timed out. Try again or tap “I finished connecting”.';
    }
    return 'Connector action failed.';
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({
    required this.connectorKey,
    required this.connected,
    required this.busy,
  });

  final String connectorKey;
  final bool connected;
  final bool busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(connectorConnectProvider(connectorKey).notifier);

    if (connected) {
      return Wrap(
        spacing: context.spaceSmall,
        runSpacing: context.spaceSmall,
        children: [
          AppButton.ghost(
            label: 'Sync credentials',
            onPressed: busy ? null : () => notifier.syncCredentials(),
          ),
          AppButton.ghost(
            label: 'Reconnect',
            onPressed: busy ? null : () => notifier.connect(),
          ),
          AppButton.ghost(
            label: 'Disconnect',
            onPressed: busy ? null : () => notifier.disconnect(),
          ),
        ],
      );
    }

    return Wrap(
      spacing: context.spaceSmall,
      runSpacing: context.spaceSmall,
      children: [
        AppButton.primary(
          label: busy ? 'Connecting…' : 'Connect',
          onPressed: busy ? null : () => notifier.connect(),
        ),
        if (busy)
          AppButton.ghost(label: 'Cancel', onPressed: () => notifier.cancel()),
        AppButton.ghost(
          label: 'I finished connecting',
          onPressed: busy ? null : () => notifier.finishConnecting(),
        ),
      ],
    );
  }
}
