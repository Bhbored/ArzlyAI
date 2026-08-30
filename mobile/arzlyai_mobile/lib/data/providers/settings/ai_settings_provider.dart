import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/repositories/settings/ai_settings_repository.dart';

part 'ai_settings_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
Future<DefaultAiModel?> defaultAiModel(Ref ref) async {
  return ref.read(aiSettingsRepositoryProvider).readDefault();
}

@Riverpod(retry: retry)
class DefaultAiModelController extends _$DefaultAiModelController {
  @override
  Future<DefaultAiModel?> build() async {
    return ref.read(aiSettingsRepositoryProvider).readDefault();
  }

  Future<void> save({
    required String provider,
    required String modelId,
  }) async {
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveDefault(provider: provider, modelId: modelId);
    ref.invalidate(defaultAiModelProvider);
    state = AsyncData(DefaultAiModel(provider: provider, modelId: modelId));
  }
}
