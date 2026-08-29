// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_approval_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmitApprovalRequest _$SubmitApprovalRequestFromJson(
  Map<String, dynamic> json,
) => _SubmitApprovalRequest(
  decision: const ApprovalDecisionConverter().fromJson(
    (json['decision'] as num).toInt(),
  ),
  editedContent: json['editedContent'] as String?,
  credentials: json['credentials'] == null
      ? null
      : CredentialEnvelope.fromJson(
          json['credentials'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SubmitApprovalRequestToJson(
  _SubmitApprovalRequest instance,
) => <String, dynamic>{
  'decision': const ApprovalDecisionConverter().toJson(instance.decision),
  'editedContent': instance.editedContent,
  'credentials': instance.credentials?.toJson(),
};
