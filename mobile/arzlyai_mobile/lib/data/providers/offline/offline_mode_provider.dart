import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/storage/shared_preferences/shared_preferences.dart';

part 'offline_mode_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class OfflineMode extends _$OfflineMode {
  @override
  Future<bool> build() {
    return ref.read(sharedPreferencesHandlerProvider).isOfflineMode();
  }

  Future<void> set(bool value) async {
    if (state.value == value) return;
    await ref.read(sharedPreferencesHandlerProvider).setOfflineMode(value);
    state = AsyncData(value);
  }
}
