import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/features/workflow_runs/result_screen.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_dialog.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_text_field.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = ref.watch(activeRunProvider);
    final draft = ref.watch(reviewDraftTempProvider);
    final theme = ShadTheme.of(context);
    final value = run.value;
    final original = value?.approval?.originalContent ?? '';
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final blocked = run.isLoading || !online || offlineMode;
    return Scaffold(
      appBar: AppBar(title: Text('Review', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          AppCard.standard(
            title: 'Original',
            child: Text(original, style: theme.textTheme.p),
          ),
          SizedBox(height: context.spaceMedium),
          Text('Current', style: theme.textTheme.small),
          AppTextField.reviewDraft(),
          SizedBox(height: context.spaceLarge),
          AppButton.primary(
            label: 'Accept and publish',
            onPressed: blocked
                ? null
                : () async {
                    final ok = await AppDialog.confirm(
                      context,
                      title: 'Publish',
                      message: 'Publish the original generated post to LinkedIn?',
                    );
                    if (!ok) return;
                    await ref.read(activeRunProvider.notifier).submitApproval(
                      ApprovalDecision.accept,
                    );
                    if (!context.mounted) return;
                    if (ref.read(activeRunProvider).hasError) return;
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ResultScreen()),
                    );
                  },
          ),
          SizedBox(height: context.spaceSmall),
          AppButton.primary(
            label: 'Edit and publish',
            onPressed: blocked || AppValidators.requiredNonEmpty(draft) != null
                ? null
                : () async {
                    final ok = await AppDialog.confirm(
                      context,
                      title: 'Publish edited post',
                      message: 'Publish your edited post to LinkedIn?',
                    );
                    if (!ok) return;
                    await ref.read(activeRunProvider.notifier).submitApproval(
                      ApprovalDecision.edit,
                      editedContent: ref.read(reviewDraftTempProvider),
                    );
                    if (!context.mounted) return;
                    if (ref.read(activeRunProvider).hasError) return;
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ResultScreen()),
                    );
                  },
          ),
          SizedBox(height: context.spaceSmall),
          AppButton.destructive(
            label: 'Reject',
            onPressed: blocked
                ? null
                : () async {
                    await ref.read(activeRunProvider.notifier).submitApproval(
                      ApprovalDecision.reject,
                    );
                    if (!context.mounted) return;
                    if (ref.read(activeRunProvider).hasError) return;
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ResultScreen()),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
