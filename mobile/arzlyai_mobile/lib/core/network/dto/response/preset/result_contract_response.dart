import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_contract_response.freezed.dart';
part 'result_contract_response.g.dart';

@freezed
sealed class ResultContractResponse with _$ResultContractResponse {
  const factory ResultContractResponse({
    required String key,
    required int version,
  }) = _ResultContractResponse;

  factory ResultContractResponse.fromJson(Map<String, dynamic> json) =>
      _$ResultContractResponseFromJson(json);
}
