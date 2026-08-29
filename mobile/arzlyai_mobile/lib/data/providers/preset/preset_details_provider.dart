import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_preset_key_provider.dart';
import 'package:arzlyai_mobile/data/repositories/preset_repository.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';

part 'preset_details_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class PresetDetailsNotifier extends _$PresetDetailsNotifier {
  @override
  Future<PresetDetails?> build() async {
    final key = ref.watch(selectedPresetKeyProvider);
    if (key == null) return null;
    final repo = ref.read(presetRepositoryProvider);
    final summaries = await repo.cachedSummaries();
    final version = summaries.where((s) => s.key == key).firstOrNull?.version;
    if (version != null) {
      final cached = await repo.cachedDetails(key, version);
      if (cached != null) {
        unawaited(
          Future<void>.microtask(() async {
            try {
              final fresh = await repo.refreshDetails(key);
              if (ref.mounted) state = AsyncData(fresh);
            } catch (_) {}
          }),
        );
        return cached;
      }
    }
    return repo.refreshDetails(key);
  }
}
