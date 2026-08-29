import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';

void main() {
  test('run config and review drafts survive widget rebuilds', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents', temperature: 0.4),
    );
    container.read(reviewDraftTempProvider.notifier).update('edited post');
    expect(container.read(runConfigTempProvider).topic, 'AI agents');
    expect(container.read(reviewDraftTempProvider), 'edited post');
    container.read(runConfigTempProvider.notifier);
    expect(container.read(runConfigTempProvider).topic, 'AI agents');
    expect(container.read(reviewDraftTempProvider), 'edited post');
  });
}
