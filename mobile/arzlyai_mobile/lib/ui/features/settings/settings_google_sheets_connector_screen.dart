import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_status_provider.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_connector_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_google_sheet_selector.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsGoogleSheetsConnectorScreen extends ConsumerWidget {
  const SettingsGoogleSheetsConnectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final connected = ref.watch(
      connectorLocalStatusProvider(ConnectorKeys.googleSheets),
    );
    return Scaffold(
      appBar: AppBar(title: Text('Google Sheets', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Row(
            children: [
              BrandIcon.google(size: 52),
              SizedBox(width: context.spaceSmall),
              Expanded(
                child: Text(
                  'Read receipt data and write report tabs.',
                  style: theme.textTheme.muted.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.spaceMedium),
          AppConnectorCard.googleSheets(compact: true),
          if (connected.value ?? false) ...[
            SizedBox(height: context.spaceMedium),
            const AppGoogleSheetSelector(),
          ],
        ],
      ),
    );
  }
}
