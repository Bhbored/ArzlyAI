import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/repositories/openai_model_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/openai_model.dart';

part 'openai_models_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class OpenAiModels extends _$OpenAiModels {
  @override
  Future<List<OpenAiModel>> build() async {
    final online = ref.read(internetConnectionProvider);
    final offlineMode = await ref.read(offlineModeProvider.future);
    if (!online || offlineMode) {
      throw StateError('Model catalog requires a network connection');
    }
    return ref.read(openAiModelRepositoryProvider).listModels();
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
    state = await AsyncValue.guard(
      () => ref
          .read(openAiModelRepositoryProvider)
          .listModels(forceRefresh: true),
    );
  }
}
