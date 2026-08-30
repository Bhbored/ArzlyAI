import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/providers/credentials/credential_requirements_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/settings_credentials_temp.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';

part 'settings_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(retry: retry)
class SettingsController extends _$SettingsController {
  @override
  Future<void> build() async {
    final requirements = await ref.read(credentialRequirementsProvider.future);
    final providerKeys = requirements
        .where((requirement) => !requirement.groupKey.contains('.'))
        .map((requirement) => requirement.envelopeKey)
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
  }
}
