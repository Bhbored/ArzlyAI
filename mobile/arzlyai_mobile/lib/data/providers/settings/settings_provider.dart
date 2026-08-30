import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/models/providers_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/settings_credentials_temp.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';

part 'settings_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(retry: retry)
class SettingsController extends _$SettingsController {
  @override
  Future<void> build() async {
    final providers = await ref.read(providersCatalogProvider.future);
    final providerKeys = providers
        .map((provider) => providerCredentialEnvelopeKey(provider.key))
        .toList();
    final repo = ref.read(credentialRepositoryProvider);
    final stored = await repo.readDraftValues(providerKeys);
    ref
        .read(settingsCredentialsTempProvider.notifier)
        .update(SettingsCredentialsState(credentialValues: stored));
  }

  Future<void> save() async {
    final draft = ref.read(settingsCredentialsTempProvider);
    await ref
        .read(credentialRepositoryProvider)
        .saveDraftValues(draft.credentialValues);
    final providers = await ref.read(providersCatalogProvider.future);
    final keyed = await ref
        .read(providerModelRepositoryProvider)
        .providersWithSavedKeys(providers.map((item) => item.key).toList());
    for (final provider in keyed) {
      await ref
          .read(availableProviderModelsProvider.notifier)
          .refreshProvider(provider);
    }
  }
}
