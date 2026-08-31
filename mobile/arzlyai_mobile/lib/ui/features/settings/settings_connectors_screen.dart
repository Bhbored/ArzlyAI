import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_status_provider.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_gmail_connector_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_google_calendar_connector_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_google_sheets_connector_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_google_tasks_connector_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_linkedin_connector_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_grouped_list.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsConnectorsScreen extends ConsumerWidget {
  const SettingsConnectorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectors', style: theme.textTheme.h4),
      ),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Text(
            'Connect external services one at a time. OAuth tokens stay on this device.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceMedium),
          SettingsGroupedList(
            dividerIndent: context.paddingMedium + 40 + context.spaceSmall,
            children: [
              _ConnectorRow(
                connectorKey: ConnectorKeys.linkedin,
                screen: const SettingsLinkedInConnectorScreen(),
                icon: BrandIcon.linkedin(),
              ),
              _ConnectorRow(
                connectorKey: ConnectorKeys.googleSheets,
                screen: const SettingsGoogleSheetsConnectorScreen(),
                icon: BrandIcon.google(),
              ),
              _ConnectorRow(
                connectorKey: ConnectorKeys.gmail,
                screen: const SettingsGmailConnectorScreen(),
                icon: BrandIcon.google(),
              ),
              _ConnectorRow(
                connectorKey: ConnectorKeys.googleTasks,
                screen: const SettingsGoogleTasksConnectorScreen(),
                icon: BrandIcon.google(),
              ),
              _ConnectorRow(
                connectorKey: ConnectorKeys.googleCalendar,
                screen: const SettingsGoogleCalendarConnectorScreen(),
                icon: BrandIcon.google(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConnectorRow extends ConsumerWidget {
  const _ConnectorRow({
    required this.connectorKey,
    required this.screen,
    required this.icon,
  });

  final String connectorKey;
  final Widget screen;
  final Widget icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(connectorLocalStatusProvider(connectorKey));
    return SettingsListRow(
      leading: icon,
      title: connectorSettingsLabel(connectorKey),
      subtitle: connected.when(
        data: (value) => value ? 'Connected' : 'Not connected',
        loading: () => 'Checking connection…',
        error: (_, _) => 'Not connected',
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => screen),
      ),
    );
  }
}
