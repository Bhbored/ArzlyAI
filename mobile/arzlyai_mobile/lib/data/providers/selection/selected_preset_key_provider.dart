import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_preset_key_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class SelectedPresetKey extends _$SelectedPresetKey {
  @override
  String? build() => null;

  void update(String? next) => state = next;

  void clear() => state = null;
}
