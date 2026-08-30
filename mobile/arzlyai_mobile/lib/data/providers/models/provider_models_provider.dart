import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/providers/models/providers_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';

part 'provider_models_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class AvailableProviderModels extends _$AvailableProviderModels {
  @override
  Future<List<ProviderModel>> build() async {
    final online = ref.read(internetConnectionProvider);
    final offlineMode = await ref.read(offlineModeProvider.future);
    if (!online || offlineMode) {
      final catalog = await ref.read(providersCatalogProvider.future);
      final repo = ref.read(providerModelRepositoryProvider);
      final models = <ProviderModel>[];
      for (final provider in catalog) {
        models.addAll(await repo.cachedModelsForProvider(provider.key));
      }
      if (models.isEmpty) {
        throw StateError('Model catalog requires a network connection');
      }
      return models;
    }
    final catalog = await ref.read(providersCatalogProvider.future);
    return ref
        .read(providerModelRepositoryProvider)
        .listModelsForProviders(catalog.map((item) => item.key).toList());
  }

  Future<void> refresh() async {
    final online = ref.read(internetConnectionProvider);
    final offlineMode = await ref.read(offlineModeProvider.future);
    if (!online || offlineMode) {
      state = AsyncError(
        StateError('Model catalog requires a network connection'),
        StackTrace.current,
      );
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final catalog = await ref.read(providersCatalogProvider.future);
      return ref
          .read(providerModelRepositoryProvider)
          .listModelsForProviders(
            catalog.map((item) => item.key).toList(),
            forceRefresh: true,
          );
    });
  }

  Future<void> refreshProvider(String provider) async {
    final online = ref.read(internetConnectionProvider);
    final offlineMode = await ref.read(offlineModeProvider.future);
    if (!online || offlineMode) {
      state = AsyncError(
        StateError('Model catalog requires a network connection'),
        StackTrace.current,
      );
      return;
    }
    await ref
        .read(providerModelRepositoryProvider)
        .listModelsForProvider(provider, forceRefresh: true);
    ref.invalidateSelf();
  }
}
