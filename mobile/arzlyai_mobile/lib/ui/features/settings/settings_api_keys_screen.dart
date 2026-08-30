import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/data/providers/models/providers_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/settings_credentials_temp.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_api_key_screen.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/ai_provider_brand.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_grouped_list.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class SettingsApiKeysScreen extends ConsumerWidget {
  const SettingsApiKeysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsControllerProvider);
    final providersAsync = ref.watch(providersCatalogProvider);
    final credentials = ref.watch(settingsCredentialsTempProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('API keys', style: theme.textTheme.h4)),
      body: providersAsync.when(
        loading: () => const AppScreenLoader(),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(context.paddingMedium),
            child: Text(
              '$error',
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
          ),
        ),
        data: (providers) => ListView(
          padding: EdgeInsets.all(context.paddingMedium),
          children: [
            Text(
              'Keys are loaded from secure storage. Tap a provider to view, replace, or clear its key.',
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            SizedBox(height: context.spaceMedium),
            SettingsGroupedList(
              dividerIndent:
                  context.paddingMedium + 40 + context.spaceSmall,
              children: providers
                  .map(
                    (provider) => SettingsListRow(
                      leading: AiProviderBrand(providerKey: provider.key),
                      title: provider.displayName,
                      subtitle: _isConfigured(credentials, provider.key)
                          ? 'Key saved'
                          : 'Not configured',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              SettingsApiKeyScreen(provider: provider),
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  static bool _isConfigured(
    SettingsCredentialsState credentials,
    String providerKey,
  ) {
    final value =
        credentials.credentialValues[providerCredentialEnvelopeKey(providerKey)];
    return value != null && value.trim().isNotEmpty;
  }
}
