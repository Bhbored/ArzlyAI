import 'dart:convert';

abstract final class NotificationActions {
  static const review = 'review';
  static const run = 'run';
}

class NotificationPayload {
  const NotificationPayload({
    required this.action,
    this.localWorkflowId,
    this.runId,
  });

  final String action;
  final String? localWorkflowId;
  final String? runId;

  Map<String, dynamic> toJson() => {
    'action': action,
    if (localWorkflowId != null) 'localWorkflowId': localWorkflowId,
    if (runId != null) 'runId': runId,
  };

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      action: json['action'] as String,
      localWorkflowId: json['localWorkflowId'] as String?,
      runId: json['runId'] as String?,
    );
  }

  String encode() => jsonEncode(toJson());

  static NotificationPayload? decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return NotificationPayload.fromJson(json);
    } on Object {
      return null;
    }
  }
}
