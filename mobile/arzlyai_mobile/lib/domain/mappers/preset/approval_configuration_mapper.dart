import 'dart:convert';

import 'package:arzlyai_mobile/domain/entities/preset/approval_configuration.dart';

class ApprovalConfigurationMapper {
  const ApprovalConfigurationMapper();

  ApprovalNodeConfiguration? fromJsonString(String? json) {
    if (json == null || json.trim().isEmpty) return null;
    final root = jsonDecode(json) as Map<String, dynamic>;
    if (!root.containsKey('acceptLabel') &&
        !root.containsKey('editLabel') &&
        !root.containsKey('rejectLabel')) {
      return null;
    }
    return ApprovalNodeConfiguration(
      acceptLabel: root['acceptLabel'] as String? ?? 'Accept',
      editLabel: root['editLabel'] as String? ?? 'Edit',
      rejectLabel: root['rejectLabel'] as String? ?? 'Reject',
    );
  }
}
