import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_dialog.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_text_field.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class LinkedInReviewPanel extends ConsumerStatefulWidget {
  const LinkedInReviewPanel({required this.run, super.key});

  final WorkflowRun run;

  @override
  ConsumerState<LinkedInReviewPanel> createState() =>
      _LinkedInReviewPanelState();
}

class _LinkedInReviewPanelState extends ConsumerState<LinkedInReviewPanel> {
  bool _submitting = false;

  WorkflowRun _resolvedRun() {
    final live = ref.watch(activeRunProvider).value;
    return live ?? widget.run;
  }

  Future<void> _submit(
    ApprovalDecision decision, {
    String? editedContent,
  }) async {
    setState(() => _submitting = true);
    await ref
        .read(activeRunProvider.notifier)
        .submitApproval(decision, editedContent: editedContent);
    if (!mounted) return;
    setState(() => _submitting = false);
    final result = ref.read(activeRunProvider);
    if (result.hasError) return;
    final run = result.value;
    if (run == null) return;
    if (decision == ApprovalDecision.edit &&
        run.status == WorkflowRunStatus.waitingForApproval) {
      ref.read(reviewDraftTempProvider.notifier).clear();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final run = _resolvedRun();
    final draft = ref.watch(reviewDraftTempProvider);
    final active = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    final snapshot = run.approval;
    final draftText =
        snapshot?.currentContent ?? snapshot?.originalContent ?? '';
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final busy = _submitting || active.isLoading || !online || offlineMode;

    return AppLoadingOverlay(
      visible: _submitting,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Review content',
            style: theme.textTheme.h4.copyWith(
              color: theme.colorScheme.foreground,
            ),
          ),
          SizedBox(height: context.spaceSmall),
          AppCard.standard(
            title: 'Generated draft',
            child: Text(draftText, style: theme.textTheme.p),
          ),
          SizedBox(height: context.spaceMedium),
          Text('Edit feedback', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          Text(
            'Describe how the AI should revise the post. A new draft will be generated.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceSmall / 2),
          AppTextField.reviewDraft(),
          SizedBox(height: context.spaceMedium),
          AppButton.primary(
            label: 'Accept and publish',
            onPressed: busy
                ? null
                : () async {
                    final ok = await AppDialog.confirm(
                      context,
                      title: 'Publish',
                      message:
                          'Publish the original generated post to LinkedIn?',
                    );
                    if (!ok || !mounted) return;
                    await _submit(ApprovalDecision.accept);
                  },
          ),
          SizedBox(height: context.spaceSmall),
          AppButton.primary(
            label: 'Request an edit',
            onPressed: busy || AppValidators.requiredNonEmpty(draft) != null
                ? null
                : () async {
                    final ok = await AppDialog.confirm(
                      context,
                      title: 'Request an edit',
                      message:
                          'Send your feedback to the AI writer and generate a new draft?',
                    );
                    if (!ok || !mounted) return;
                    await _submit(
                      ApprovalDecision.edit,
                      editedContent: ref.read(reviewDraftTempProvider),
                    );
                  },
          ),
          SizedBox(height: context.spaceSmall),
          AppButton.destructive(
            label: 'Reject',
            onPressed: busy
                ? null
                : () async {
                    final ok = await AppDialog.confirm(
                      context,
                      title: 'Reject',
                      message: 'Reject this post and cancel the workflow?',
                    );
                    if (!ok || !mounted) return;
                    await _submit(ApprovalDecision.reject);
                  },
          ),
        ],
      ),
    );
  }
}
