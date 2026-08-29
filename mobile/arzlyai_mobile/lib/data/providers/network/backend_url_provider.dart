import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';

part 'backend_url_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class BackendUrl extends _$BackendUrl {
  @override
  Future<String> build() async {
    return ApiConfig.resolveBaseUrl(null);
  }
}
