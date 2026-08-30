import 'package:arzlyai_mobile/core/network/dto/response/models/openai_model_response.dart';
import 'package:arzlyai_mobile/domain/entities/provider/openai_model.dart';

class OpenAiModelMapper {
  const OpenAiModelMapper();

  OpenAiModel fromDto(OpenAiModelResponse dto) {
    return OpenAiModel(
      id: dto.id,
      displayName: dto.displayName,
      ownedBy: dto.ownedBy,
      createdAtUtc: dto.createdAtUtc,
      supportsTemperature: dto.supportsTemperature,
      supportsWebSearch: dto.supportsWebSearch,
    );
  }
}
