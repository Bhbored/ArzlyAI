import 'package:arzlyai_mobile/core/network/dto/response/models/provider_model_response.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';

class ProviderModelMapper {
  const ProviderModelMapper();

  ProviderModel fromDto(ProviderModelResponse dto) {
    return ProviderModel(
      id: dto.id,
      displayName: dto.displayName,
      provider: dto.provider,
      ownedBy: dto.ownedBy,
      createdAtUtc: dto.createdAtUtc,
      supportsTemperature: dto.supportsTemperature,
      supportsWebSearch: dto.supportsWebSearch,
    );
  }

  Map<String, dynamic> toJson(ProviderModel model) => {
    'id': model.id,
    'displayName': model.displayName,
    'provider': model.provider,
    'ownedBy': model.ownedBy,
    'createdAtUtc': model.createdAtUtc.toIso8601String(),
    'supportsTemperature': model.supportsTemperature,
    'supportsWebSearch': model.supportsWebSearch,
  };

  ProviderModel fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      provider: json['provider'] as String,
      ownedBy: json['ownedBy'] as String,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      supportsTemperature: json['supportsTemperature'] as bool,
      supportsWebSearch: json['supportsWebSearch'] as bool? ?? false,
    );
  }
}
