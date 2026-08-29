import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';

part 'submit_approval_request.freezed.dart';
part 'submit_approval_request.g.dart';

@freezed
sealed class SubmitApprovalRequest with _$SubmitApprovalRequest {
  const factory SubmitApprovalRequest({
    @ApprovalDecisionConverter() required ApprovalDecision decision,
    String? editedContent,
    CredentialEnvelope? credentials,
  }) = _SubmitApprovalRequest;

  factory SubmitApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitApprovalRequestFromJson(json);
}
