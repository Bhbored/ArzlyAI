import 'package:arzlyai_mobile/domain/entities/geo/country.dart';

class CountryMapper {
  const CountryMapper();

  Country? fromJson(Map<String, dynamic> json) {
    final code = json['iso2'] as String? ?? json['cca2'] as String?;
    final rawName = json['name'];
    final name = rawName is String
        ? rawName
        : rawName is Map
        ? rawName['common'] as String?
        : null;
    if (code == null || name == null) return null;
    return Country(
      code: code,
      name: name,
      flagUrl: 'https://flagcdn.com/w40/${code.toLowerCase()}.png',
    );
  }
}
