import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/services/geo/countries_catalog_service.dart';
import 'package:arzlyai_mobile/domain/entities/geo/country.dart';
import 'package:arzlyai_mobile/domain/mappers/geo/country_mapper.dart';

part 'country_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
CountryRepository countryRepository(Ref ref) {
  return CountryRepository(
    ref.read(countriesCatalogServiceProvider),
    const CountryMapper(),
  );
}

class CountryRepository {
  CountryRepository(this._service, this._mapper);

  final CountriesCatalogService _service;
  final CountryMapper _mapper;
  List<Country>? _cache;

  Future<List<Country>> listCountries({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache != null) return _cache!;
    final payload = await _service.fetchAll();
    final countries = payload
        .map(_mapper.fromJson)
        .whereType<Country>()
        .toList(growable: false)
      ..sort((a, b) => a.name.compareTo(b.name));
    _cache = countries;
    return countries;
  }
}
