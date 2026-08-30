import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/connectors/connector_status_provider.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_google_connector_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_linkedin_connector_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_grouped_list.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsConnectorsScreen extends ConsumerWidget {
  const SettingsConnectorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final linkedInConnected = ref.watch(
      connectorLocalStatusProvider(ConnectorKeys.linkedin),
    );
    final googleConnected = ref.watch(
      connectorLocalStatusProvider(ConnectorKeys.google),
    );
    return Scaffold(
      appBar: AppBar(title: Text('Connectors', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Text(
            'Publish and sync with external services. OAuth tokens stay on this device.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceMedium),
          SettingsGroupedList(
            dividerIndent: context.paddingMedium + 40 + context.spaceSmall,
            children: [
              SettingsListRow(
                leading: BrandIcon.linkedin(),
                title: 'LinkedIn',
                subtitle: linkedInConnected.when(
                  data: (value) => value ? 'Connected' : 'Not connected',
                  loading: () => 'Checking connection…',
                  error: (_, _) => 'Not connected',
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsLinkedInConnectorScreen(),
                  ),
                ),
              ),
              SettingsListRow(
                leading: BrandIcon.google(),
                title: 'Google',
                subtitle: googleConnected.when(
                  data: (value) => value ? 'Connected' : 'Not connected',
                  loading: () => 'Checking connection…',
                  error: (_, _) => 'Not connected',
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsGoogleConnectorScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
