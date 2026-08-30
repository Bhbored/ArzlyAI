import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';

@freezed
sealed class Country with _$Country {
  const factory Country({
    required String code,
    required String name,
    required String flagUrl,
  }) = _Country;
}
