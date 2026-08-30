import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/repositories/geo/country_repository.dart';
import 'package:arzlyai_mobile/domain/entities/geo/country.dart';

part 'countries_provider.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
class Countries extends _$Countries {
  @override
  Future<List<Country>> build() async {
    final online = ref.read(internetConnectionProvider);
    final offlineMode = await ref.read(offlineModeProvider.future);
    if (!online || offlineMode) {
      throw StateError('Country list requires a network connection');
    }
    return ref.read(countryRepositoryProvider).listCountries();
  }

  Future<void> refresh() async {
    final online = ref.read(internetConnectionProvider);
    final offlineMode = await ref.read(offlineModeProvider.future);
    if (!online || offlineMode) {
      state = AsyncError(
        StateError('Country list requires a network connection'),
        StackTrace.current,
      );
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(countryRepositoryProvider).listCountries(forceRefresh: true),
    );
  }
}
