import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_model.freezed.dart';

@freezed
sealed class ProviderModel with _$ProviderModel {
  const factory ProviderModel({
    required String id,
    required String displayName,
    required String provider,
    required String ownedBy,
    required DateTime createdAtUtc,
    required bool supportsTemperature,
    required bool supportsWebSearch,
  }) = _ProviderModel;
}
