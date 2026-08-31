import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/action_plan_report_view.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class BrainDumpResultScreen extends ConsumerWidget {
  const BrainDumpResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = ref.watch(activeRunProvider).value;
    final theme = ShadTheme.of(context);
    if (run == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Action plan', style: theme.textTheme.h4)),
        body: Center(child: Text('No run', style: theme.textTheme.p)),
      );
    }
    final synced = run.status == WorkflowRunStatus.completed;
    return Scaffold(
      appBar: AppBar(title: Text('Action plan', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          if (synced)
            AppCard.standard(
              title: 'Plan ready',
              child: Text(
                'Your approved plan finished processing. Sync steps that were '
                'enabled ran on this device.',
                style: theme.textTheme.muted,
              ),
            ),
          SizedBox(height: context.spaceMedium),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            child: ActionPlanReportView(run: run),
          ),
        ],
      ),
    );
  }
}
