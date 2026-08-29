import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/execution_screen.dart';
import '../../helpers/test_app.dart';

class _Running extends ActiveRun {
  @override
  Future<WorkflowRun?> build() async {
    return const WorkflowRun(
      runId: 'run-1',
      presetKey: 'daily-linkedin-ai-post',
      status: WorkflowRunStatus.running,
      nodes: [
        WorkflowNodeRun(
          nodeId: 'n1',
          nodeKey: 'content-writer',
          displayName: 'AI Content Writer',
          type: 'Agent',
          status: WorkflowNodeStatus.running,
          isRunning: true,
        ),
      ],
    );
  }
}

void main() {
  testWidgets('execution shows running progress without leaving the screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [activeRunProvider.overrideWith(_Running.new)],
        child: testApp(home: const ExecutionScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Execution'), findsOneWidget);
    expect(find.text('AI Content Writer'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 16));
    expect(find.text('Execution'), findsOneWidget);
  });
}
