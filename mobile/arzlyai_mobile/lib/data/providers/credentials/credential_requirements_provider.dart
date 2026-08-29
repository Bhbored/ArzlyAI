import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/repositories/preset_repository.dart';
import 'package:arzlyai_mobile/domain/entities/credentials/credential_requirement.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';

part 'credential_requirements_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
Future<List<CredentialRequirement>> credentialRequirements(Ref ref) async {
  final repo = ref.read(presetRepositoryProvider);
  final summaries = await repo.cachedSummaries();
  final requirements = <CredentialRequirement>[];
  final seen = <String>{};

  for (final summary in summaries) {
    final cached = await repo.cachedDetails(summary.key, summary.version);
    if (cached != null) {
      _mergeRequirements(requirements, seen, cached.credentialRequirements());
      continue;
    }
    try {
      final fresh = await repo.refreshDetails(summary.key);
      _mergeRequirements(requirements, seen, fresh.credentialRequirements());
    } catch (_) {}
  }

  requirements.sort((a, b) => a.groupLabel.compareTo(b.groupLabel));
  return requirements;
}

void _mergeRequirements(
  List<CredentialRequirement> requirements,
  Set<String> seen,
  List<CredentialRequirement> next,
) {
  for (final requirement in next) {
    if (seen.add(requirement.envelopeKey)) {
      requirements.add(requirement);
    }
  }
}
