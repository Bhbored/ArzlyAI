import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/providers/network/backend_url_provider.dart';
import 'package:arzlyai_mobile/data/repositories/preset/preset_repository.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';

part 'preset_catalog_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class PresetCatalog extends _$PresetCatalog {
  @override
  Future<List<PresetSummary>> build() async {
    await ref.watch(backendUrlProvider.future);
    final repo = ref.read(presetRepositoryProvider);
    final cached = await repo.cachedSummaries();
    if (cached.isNotEmpty) {
      unawaited(
        Future<void>.microtask(() async {
          try {
            final fresh = await repo.refreshSummaries();
            if (ref.mounted) state = AsyncData(fresh);
          } catch (_) {}
        }),
      );
      return cached;
    }
    return repo.refreshSummaries();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(presetRepositoryProvider).refreshSummaries(),
    );
  }
}
