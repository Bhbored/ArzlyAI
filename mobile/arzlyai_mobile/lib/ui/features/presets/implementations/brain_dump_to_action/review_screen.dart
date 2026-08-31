import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run_support.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/action_plan_report_view.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_text_field.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class BrainDumpReviewScreen extends ConsumerStatefulWidget {
  const BrainDumpReviewScreen({super.key});

  @override
  ConsumerState<BrainDumpReviewScreen> createState() =>
      _BrainDumpReviewScreenState();
}

class _BrainDumpReviewScreenState extends ConsumerState<BrainDumpReviewScreen> {
  var _showFeedback = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(activeRunProvider.notifier).refreshSnapshot();
    });
  }

  WorkflowNode? _waitingNode(PresetDetails? preset, WorkflowRun? run) {
    if (preset == null || run == null) return null;
    final index = run.waitingApprovalIndex();
    if (index == null) return null;
    final nodeRun = run.nodes[index];
    return preset.workflow.nodes
        .where((node) => node.id == nodeRun.nodeId)
        .firstOrNull;
  }

  void _submit(ApprovalDecision decision, {String? editedContent}) {
    ref
        .read(activeRunProvider.notifier)
        .submitApproval(decision, editedContent: editedContent);
    if (decision == ApprovalDecision.edit) {
      ref.read(reviewDraftTempProvider.notifier).clear();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final run = ref.watch(activeRunProvider).value;
    final preset = ref.watch(presetDetailsProvider).value;
    final draft = ref.watch(reviewDraftTempProvider);
    final theme = ShadTheme.of(context);
    final waitingNode = _waitingNode(preset, run);
    final labels = waitingNode?.approvalConfiguration;

    return Scaffold(
      appBar: AppBar(title: Text('Review plan', style: theme.textTheme.h4)),
      body: run == null
          ? Center(child: Text('No run', style: theme.textTheme.p))
          : ListView(
              padding: EdgeInsets.all(context.paddingMedium),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  child: ActionPlanReportView(run: run),
                ),
                SizedBox(height: context.spaceMedium),
                if (_showFeedback) ...[
                  AppTextField.reviewDraft(),
                  SizedBox(height: context.spaceMedium),
                ],
                AppButton.primary(
                  label: labels?.acceptLabel ?? 'Approve and sync',
                  onPressed: () => _submit(ApprovalDecision.accept),
                ),
                SizedBox(height: context.spaceSmall),
                AppButton.ghost(
                  label: labels?.editLabel ?? 'Revise plan',
                  onPressed: () {
                    if (!_showFeedback) {
                      setState(() => _showFeedback = true);
                      return;
                    }
                    if (AppValidators.requiredNonEmpty(draft) != null) return;
                    _submit(ApprovalDecision.edit, editedContent: draft.trim());
                  },
                ),
                SizedBox(height: context.spaceSmall),
                AppButton.destructive(
                  label: labels?.rejectLabel ?? 'Discard',
                  onPressed: () => _submit(ApprovalDecision.reject),
                ),
              ],
            ),
    );
  }
}
