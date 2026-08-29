import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class AppRunResultPanel extends StatelessWidget {
  const AppRunResultPanel({required this.run, super.key});

  final WorkflowRun run;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final published = run.status == WorkflowRunStatus.completed &&
        run.finalResponse != null &&
        run.finalResponse!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Run result',
          style: theme.textTheme.h4.copyWith(color: theme.colorScheme.foreground),
        ),
        SizedBox(height: context.spaceSmall),
        AppCard.standard(
          title: run.status.wireValue,
          child: Text(
            published
                ? 'LinkedIn post: ${run.finalResponse}'
                : (run.finalResponse ??
                      'No LinkedIn identifier. Publication is confirmed only by this identifier.'),
            style: theme.textTheme.p,
          ),
        ),
      ],
    );
  }
}
