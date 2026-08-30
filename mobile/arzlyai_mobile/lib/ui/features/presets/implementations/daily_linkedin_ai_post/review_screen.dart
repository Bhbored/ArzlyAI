import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/linkedin_review_panel.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_toast.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runAsync = ref.watch(activeRunProvider);
    final runId = ref.watch(selectedRunIdProvider);
    final theme = ShadTheme.of(context);
    final run = runAsync.value;

    if (run != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Review', style: theme.textTheme.h4)),
        body: ListView(
          padding: EdgeInsets.all(context.paddingMedium),
          children: [LinkedInReviewPanel(run: run)],
        ),
      );
    }

    if (runId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Review', style: theme.textTheme.h4)),
        body: Center(child: Text('No run', style: theme.textTheme.p)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Review', style: theme.textTheme.h4)),
      body: FutureBuilder(
        future: ref.read(workflowRepositoryProvider).getLocalRun(runId),
        builder: (context, snapshot) {
          final local = snapshot.data;
          if (local != null) {
            return ListView(
              padding: EdgeInsets.all(context.paddingMedium),
              children: [LinkedInReviewPanel(run: local)],
            );
          }
          if (runAsync.hasError) {
            return Center(
              child: Text(
                AppToast.messageFor(runAsync.error!),
                style: theme.textTheme.p,
              ),
            );
          }
          return Center(child: Text('No run', style: theme.textTheme.p));
        },
      ),
    );
  }
}
