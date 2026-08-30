import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/domain/mappers/geo/country_mapper.dart';

void main() {
  const mapper = CountryMapper();

  test('maps countriesnow payload', () {
    final country = mapper.fromJson({
      'iso2': 'FR',
      'name': 'France',
      'flag': 'https://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg',
    });

    expect(country?.code, 'FR');
    expect(country?.name, 'France');
    expect(country?.flagUrl, 'https://flagcdn.com/w40/fr.png');
  });
}
