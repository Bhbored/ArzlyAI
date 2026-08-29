import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Result', style: theme.textTheme.h4)),
      body: run.when(
        data: (value) {
          if (value == null) {
            return Center(child: Text('No result', style: theme.textTheme.p));
          }
          final published = value.status == WorkflowRunStatus.completed &&
              value.finalResponse != null &&
              value.finalResponse!.isNotEmpty;
          return ListView(
            padding: EdgeInsets.all(context.paddingMedium),
            children: [
              AppCard.standard(
                title: value.status.wireValue,
                child: Text(
                  published
                      ? 'LinkedIn post: ${value.finalResponse}'
                      : (value.finalResponse ??
                            'No LinkedIn identifier. Publication is confirmed only by this identifier.'),
                  style: theme.textTheme.p,
                ),
              ),
            ],
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) {
          final message = error is ApiException ? error.userMessage : '$error';
          final correlation = error is ApiException ? error.correlationId : null;
          return AppStatus.error(message: message, correlationId: correlation);
        },
      ),
    );
  }
}
