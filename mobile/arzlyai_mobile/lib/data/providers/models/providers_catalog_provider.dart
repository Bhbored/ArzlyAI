import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/models/provider_response.dart';
import 'package:arzlyai_mobile/core/network/services/models/provider_model_service.dart';

part 'providers_catalog_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
Future<List<ProviderResponse>> providersCatalog(Ref ref) async {
  return ref.read(providerModelServiceProvider).listProviders();
}
