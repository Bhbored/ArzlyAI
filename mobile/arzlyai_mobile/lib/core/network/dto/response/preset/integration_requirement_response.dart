import 'package:freezed_annotation/freezed_annotation.dart';

part 'integration_requirement_response.freezed.dart';
part 'integration_requirement_response.g.dart';

@freezed
sealed class IntegrationRequirementResponse
    with _$IntegrationRequirementResponse {
  const factory IntegrationRequirementResponse({
    required String key,
    required String name,
    required String description,
    required String credentialSchemaJson,
  }) = _IntegrationRequirementResponse;

  factory IntegrationRequirementResponse.fromJson(Map<String, dynamic> json) =>
      _$IntegrationRequirementResponseFromJson(json);
}
