import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/notifications/notification_payload.dart';

void main() {
  test('payload encodes identifiers without secrets', () {
    const payload = NotificationPayload(
      action: NotificationActions.review,
      localWorkflowId: 'wf-1',
      runId: 'run-1',
    );
    final encoded = payload.encode();
    expect(encoded.contains('sk-'), isFalse);
    expect(encoded.contains('access_token'), isFalse);
    expect(NotificationPayload.decode(encoded)?.runId, 'run-1');
    expect(NotificationPayload.decode(encoded)?.action, NotificationActions.review);
  });

  test('invalid payload decode returns null', () {
    expect(NotificationPayload.decode('not-json'), isNull);
    expect(NotificationPayload.decode(null), isNull);
  });
}
