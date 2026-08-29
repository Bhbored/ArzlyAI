import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/review_screen.dart';
import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';

class _Waiting extends ActiveRun {
  @override
  Future<WorkflowRun?> build() async {
    return const WorkflowRunMapper().fromDto(waitingRunDto());
  }
}

void main() {
  testWidgets('review shows original and current snapshots separately', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeRunProvider.overrideWith(_Waiting.new),
          internetConnectionProvider.overrideWithValue(true),
          offlineModeProvider.overrideWith(OnlineMode.new),
          reviewDraftTempProvider.overrideWith(_Draft.new),
        ],
        child: testApp(home: const ReviewScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Generated draft'), findsOneWidget);
    expect(find.text('Edit feedback'), findsOneWidget);
    expect(
      find.text(
        'Describe how the AI should revise the post. A new draft will be generated.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('AI agents are useful when they stay grounded in facts.'),
      findsWidgets,
    );
    expect(find.text('Accept and publish'), findsOneWidget);
    expect(find.text('Request an edit'), findsOneWidget);
    expect(find.text('Reject'), findsOneWidget);
  });

  testWidgets('review publish actions are disabled offline', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeRunProvider.overrideWith(_Waiting.new),
          internetConnectionProvider.overrideWithValue(false),
          offlineModeProvider.overrideWith(OnlineMode.new),
          reviewDraftTempProvider.overrideWith(_Draft.new),
        ],
        child: testApp(home: const ReviewScreen()),
      ),
    );
    await tester.pump();
    final buttons = tester.widgetList<ShadButton>(find.byType(ShadButton));
    expect(buttons.every((button) => button.onPressed == null), isTrue);
  });
}

class _Draft extends ReviewDraftTemp {
  @override
  String build() => 'AI agents are useful when they stay grounded in facts.';
}
