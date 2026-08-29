import 'package:freezed_annotation/freezed_annotation.dart';

part 'credential_requirement.freezed.dart';

@freezed
sealed class CredentialRequirement with _$CredentialRequirement {
  const factory CredentialRequirement({
    required String envelopeKey,
    required String label,
    required String groupKey,
    required String groupLabel,
    required bool obscure,
  }) = _CredentialRequirement;
}

enum CredentialPhase { workflowStart, approval, editRequest }
