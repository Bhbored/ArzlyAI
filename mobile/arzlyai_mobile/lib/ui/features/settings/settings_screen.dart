import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/data/providers/connectors/linkedin_connector_status_provider.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/models/providers_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/settings_credentials_temp.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_api_keys_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_connectors_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_default_model_screen.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_nav_tile.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsControllerProvider);
    final providersAsync = ref.watch(providersCatalogProvider);
    final credentials = ref.watch(settingsCredentialsTempProvider);
    final linkedIn = ref.watch(linkedInConnectorStatusProvider);
    final defaultModel = ref.watch(defaultAiModelProvider);
    final models = ref.watch(availableProviderModelsProvider).value;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: theme.textTheme.h4)),
      body: providersAsync.when(
        loading: () => const AppScreenLoader(),
        error: (error, _) => Center(
          child: Text(
            '$error',
            style: theme.textTheme.p.copyWith(
              color: theme.colorScheme.destructive,
            ),
          ),
        ),
        data: (providers) {
          final configuredCount = providers
              .where(
                (provider) =>
                    _hasKey(credentials, providerCredentialEnvelopeKey(provider.key)),
              )
              .length;
          return ListView(
            padding: EdgeInsets.all(context.paddingMedium),
            children: [
              Text(
                'Credentials and defaults for AI workflows.',
                style: theme.textTheme.muted.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
              SizedBox(height: context.spaceMedium),
              Text('Workspace', style: theme.textTheme.small),
              SizedBox(height: context.spaceSmall),
              SettingsNavTile(
                icon: LucideIcons.unplug,
                title: 'Connectors',
                subtitle: linkedIn.when(
                  data: (connected) =>
                      connected ? 'LinkedIn connected' : 'LinkedIn not connected',
                  loading: () => 'Checking LinkedIn…',
                  error: (_, _) => 'LinkedIn not connected',
                ),
                onTap: () => _open(context, const SettingsConnectorsScreen()),
              ),
              SettingsNavTile(
                icon: LucideIcons.keyRound,
                title: 'API keys',
                subtitle: configuredCount == 0
                    ? 'No provider keys saved'
                    : '$configuredCount of ${providers.length} providers configured',
                onTap: () => _open(context, const SettingsApiKeysScreen()),
              ),
              SettingsNavTile(
                icon: LucideIcons.bot,
                title: 'Default model',
                subtitle: defaultModel.when(
                  data: (value) {
                    if (value == null) return 'Pick a model for new runs';
                    final match = models == null
                        ? null
                        : ref
                            .read(providerModelRepositoryProvider)
                            .findModel(models, value.modelId);
                    final label = match?.displayName ?? value.modelId;
                    return '$label · ${value.provider}';
                  },
                  loading: () => 'Loading default…',
                  error: (_, _) => 'Pick a model for new runs',
                ),
                onTap: () => _open(context, const SettingsDefaultModelScreen()),
              ),
            ],
          );
        },
      ),
    );
  }

  static bool _hasKey(SettingsCredentialsState credentials, String key) {
    final value = credentials.credentialValues[key];
    return value != null && value.trim().isNotEmpty;
  }

  static void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}
