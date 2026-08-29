import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/repositories/workflow_repository.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/linkedin_review_panel.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  String _messageFor(Object error) {
    if (error is HandshakeException || error is TlsException) {
      return ApiErrors.certificateFailed;
    }
    return '$error';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = ref.watch(activeRunProvider);
    final runId = ref.watch(selectedRunIdProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Review', style: theme.textTheme.h4)),
      body: run.when(
        data: (value) {
          if (value == null) {
            return Center(child: Text('No run', style: theme.textTheme.p));
          }
          return ListView(
            padding: EdgeInsets.all(context.paddingMedium),
            children: [
              LinkedInReviewPanel(run: value),
            ],
          );
        },
        loading: () => const AppScreenLoader(),
        error: (error, _) {
          if (runId == null) {
            return Center(
              child: Text(_messageFor(error), style: theme.textTheme.p),
            );
          }
          return FutureBuilder(
            future: ref.read(workflowRepositoryProvider).getLocalRun(runId),
            builder: (context, snapshot) {
              final local = snapshot.data;
              if (local != null) {
                return ListView(
                  padding: EdgeInsets.all(context.paddingMedium),
                  children: [
                    LinkedInReviewPanel(run: local),
                  ],
                );
              }
              return Center(
                child: Text(_messageFor(error), style: theme.textTheme.p),
              );
            },
          );
        },
      ),
    );
  }
}
