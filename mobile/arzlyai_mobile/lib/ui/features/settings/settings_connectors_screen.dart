import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_status_provider.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_google_account_screen.dart';
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
            'Connect external services for workflow delivery. Google authorization '
            'runs natively on this device; the backend only receives short-lived '
            'encrypted tokens when a workflow or resource query runs.',
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
                icon: BrandIcon.connector(ConnectorKeys.linkedin),
              ),
              _GoogleAccountRow(
                icon: BrandIcon.connector(ConnectorKeys.googleSheets),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoogleAccountRow extends ConsumerWidget {
  const _GoogleAccountRow({required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheets = ref.watch(connectorLocalStatusProvider(ConnectorKeys.googleSheets));
    final gmail = ref.watch(connectorLocalStatusProvider(ConnectorKeys.gmail));
    final tasks = ref.watch(connectorLocalStatusProvider(ConnectorKeys.googleTasks));
    final calendar = ref.watch(
      connectorLocalStatusProvider(ConnectorKeys.googleCalendar),
    );
    final subtitle = _googleSubtitle(sheets, gmail, tasks, calendar);
    return SettingsListRow(
      leading: icon,
      title: 'Google account',
      subtitle: subtitle,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const SettingsGoogleAccountScreen(),
        ),
      ),
    );
  }

  static String _googleSubtitle(
    AsyncValue<bool> sheets,
    AsyncValue<bool> gmail,
    AsyncValue<bool> tasks,
    AsyncValue<bool> calendar,
  ) {
    final values = [sheets, gmail, tasks, calendar];
    if (values.any((value) => value.isLoading)) {
      return 'Checking authorization…';
    }
    final authorized = values.where((value) => value.value ?? false).length;
    if (authorized == 0) return 'Not connected';
    if (authorized == ConnectorKeys.googleConnectors.length) {
      return 'All services authorized';
    }
    return '$authorized of ${ConnectorKeys.googleConnectors.length} services authorized';
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
