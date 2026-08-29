import 'package:json_annotation/json_annotation.dart';

enum ApprovalDecision { accept, edit, reject }

class ApprovalDecisionConverter
    implements JsonConverter<ApprovalDecision, int> {
  const ApprovalDecisionConverter();

  @override
  ApprovalDecision fromJson(int json) {
    if (json >= 0 && json < ApprovalDecision.values.length) {
      return ApprovalDecision.values[json];
    }
    return ApprovalDecision.reject;
  }

  @override
  int toJson(ApprovalDecision object) => object.index;
}

class ApprovalDecisionNullableConverter
    implements JsonConverter<ApprovalDecision?, int?> {
  const ApprovalDecisionNullableConverter();

  @override
  ApprovalDecision? fromJson(int? json) {
    if (json == null) return null;
    return const ApprovalDecisionConverter().fromJson(json);
  }

  @override
  int? toJson(ApprovalDecision? object) => object?.index;
}
