import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_status_provider.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_connector_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_google_sheet_selector.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsGoogleConnectorScreen extends ConsumerWidget {
  const SettingsGoogleConnectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final connected = ref.watch(
      connectorLocalStatusProvider(ConnectorKeys.google),
    );
    return Scaffold(
      appBar: AppBar(title: Text('Google', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Row(
            children: [
              BrandIcon.google(size: 52),
              SizedBox(width: context.spaceSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google connector',
                      style: theme.textTheme.p.copyWith(
                        color: theme.colorScheme.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'OAuth tokens stay in secure storage.',
                      style: theme.textTheme.muted.copyWith(
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.spaceMedium),
          Text(
            'Authorize Google Sheets and Gmail through Nango. Syncing copies the short-lived connector credentials into platform secure storage on this device.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceMedium),
          AppConnectorCard.google(compact: true),
          if (connected.value ?? false) ...[
            SizedBox(height: context.spaceMedium),
            const AppGoogleSheetSelector(),
          ],
        ],
      ),
    );
  }
}
