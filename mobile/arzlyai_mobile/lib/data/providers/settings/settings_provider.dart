import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/data/providers/credentials/credential_requirements_provider.dart';
import 'package:arzlyai_mobile/data/providers/network/backend_url_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/settings_credentials_temp.dart';
import 'package:arzlyai_mobile/data/repositories/credential_repository.dart';

part 'settings_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(retry: retry)
class SettingsController extends _$SettingsController {
  @override
  Future<void> build() async {
    final requirements = await ref.read(credentialRequirementsProvider.future);
    final repo = ref.read(credentialRepositoryProvider);
    final stored = await repo.readDraftValues(
      requirements.map((requirement) => requirement.envelopeKey).toList(),
    );
    final baseUrl =
        ref.read(backendUrlProvider).value ?? ApiConfig.defaultBaseUrl;
    ref.read(settingsCredentialsTempProvider.notifier).update(
      SettingsCredentialsState(
        backendUrl: ApiConfig.originFromBaseUrl(baseUrl),
        credentialValues: stored,
      ),
    );
  }

  Future<void> save() async {
    final draft = ref.read(settingsCredentialsTempProvider);
    await ref.read(backendUrlProvider.notifier).save(draft.backendUrl);
    await ref.read(credentialRepositoryProvider).saveDraftValues(
      draft.credentialValues,
    );
  }
}
