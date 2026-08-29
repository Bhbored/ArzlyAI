import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_node_changed_event.freezed.dart';
part 'workflow_node_changed_event.g.dart';

@freezed
sealed class WorkflowNodeChangedEvent with _$WorkflowNodeChangedEvent {
  const factory WorkflowNodeChangedEvent({
    required String runId,
    required String nodeId,
    required String nodeKey,
    required String status,
    required bool isRunning,
    required String message,
    required DateTime occurredAtUtc,
  }) = _WorkflowNodeChangedEvent;

  factory WorkflowNodeChangedEvent.fromJson(Map<String, dynamic> json) =>
      _$WorkflowNodeChangedEventFromJson(json);
}
