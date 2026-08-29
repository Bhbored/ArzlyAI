import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/storage/shared_preferences/shared_preferences.dart';

part 'backend_url_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class BackendUrl extends _$BackendUrl {
  @override
  Future<String> build() async {
    final stored = await ref
        .read(sharedPreferencesHandlerProvider)
        .getString(ApiConfig.backendUrlKey);
    final value = stored?.trim();
    if (value == null || value.isEmpty) return ApiConfig.resolveBaseUrl(null);
    return ApiConfig.resolveBaseUrl(value);
  }

  Future<void> save(String next) async {
    final trimmed = next.trim();
    final stored = trimmed.contains('/api/')
        ? ApiConfig.originFromBaseUrl(trimmed)
        : ApiConfig.parseOrigin(trimmed).toString();
    await ref
        .read(sharedPreferencesHandlerProvider)
        .setString(ApiConfig.backendUrlKey, stored);
    state = AsyncData(ApiConfig.resolveBaseUrl(stored));
  }
}
