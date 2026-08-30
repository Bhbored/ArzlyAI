import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/workflow_transport_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run_support.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_brief_panel.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_report_view.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_dialog.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_text_field.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class SmartPurchaseReviewScreen extends ConsumerStatefulWidget {
  const SmartPurchaseReviewScreen({super.key});

  @override
  ConsumerState<SmartPurchaseReviewScreen> createState() =>
      _SmartPurchaseReviewScreenState();
}

class _SmartPurchaseReviewScreenState
    extends ConsumerState<SmartPurchaseReviewScreen> {
  var _showFeedback = false;

  WorkflowNode? _waitingNode(PresetDetails? preset, WorkflowRun? run) {
    if (preset == null || run == null) return null;
    final index = run.waitingApprovalIndex();
    if (index == null) return null;
    final nodeRun = run.nodes[index];
    return preset.workflow.nodes
        .where((node) => node.id == nodeRun.nodeId)
        .firstOrNull;
  }

  void _submit(
    ApprovalDecision decision, {
    String? editedContent,
  }) {
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
    final content = run?.approval?.currentContent ?? '';
    final hasReportView = run != null &&
        (run.renderedResult != null || run.report != null);
    final hasHtml = run != null &&
        run.renderedResult?.mediaType == 'text/html' &&
        (run.renderedResult?.content.trim().isNotEmpty ?? false);
    final showFeedbackField = !hasHtml || _showFeedback;
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final transport = ref.watch(workflowTransportProvider);
    final busy = !online || offlineMode || transport.blocksApproval;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          waitingNode?.displayName ?? 'Review',
          style: theme.textTheme.h4,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                hasHtml ? context.paddingSmall : context.paddingMedium,
                hasHtml ? context.paddingSmall : context.paddingMedium,
                hasHtml ? context.paddingSmall : context.paddingMedium,
                0,
              ),
              child: run != null && hasReportView
                  ? SmartPurchaseReportView(run: run)
                  : SingleChildScrollView(
                      child: SmartPurchaseBriefPanel(content: content),
                    ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.paddingMedium,
                hasHtml ? context.paddingSmall : context.paddingMedium,
                context.paddingMedium,
                context.paddingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showFeedbackField) ...[
                    Text('Edit feedback', style: theme.textTheme.small),
                    SizedBox(height: context.spaceSmall / 2),
                    AppTextField.reviewDraft(),
                    SizedBox(
                      height: hasHtml ? context.spaceSmall : context.spaceMedium,
                    ),
                  ] else ...[
                    AppButton.ghost(
                      label: 'Add feedback',
                      onPressed: () => setState(() => _showFeedback = true),
                    ),
                    SizedBox(height: context.spaceSmall),
                  ],
                  if (hasHtml)
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.destructive(
                            label: labels?.rejectLabel ?? 'Reject',
                            onPressed: busy
                                ? null
                                : () async {
                                    final ok = await AppDialog.confirm(
                                      context,
                                      title: labels?.rejectLabel ?? 'Reject',
                                      message: 'Cancel this run?',
                                    );
                                    if (!ok || !mounted) return;
                                    _submit(ApprovalDecision.reject);
                                  },
                          ),
                        ),
                        SizedBox(width: context.spaceSmall),
                        Expanded(
                          child: AppButton.ghost(
                            label: labels?.editLabel ?? 'Edit',
                            onPressed: busy
                                ? null
                                : () async {
                                    if (!_showFeedback) {
                                      setState(() => _showFeedback = true);
                                      return;
                                    }
                                    if (AppValidators.requiredNonEmpty(draft) !=
                                        null) {
                                      return;
                                    }
                                    final ok = await AppDialog.confirm(
                                      context,
                                      title: labels?.editLabel ?? 'Edit',
                                      message: 'Send feedback and regenerate?',
                                    );
                                    if (!ok || !mounted) return;
                                    _submit(
                                      ApprovalDecision.edit,
                                      editedContent:
                                          ref.read(reviewDraftTempProvider),
                                    );
                                  },
                          ),
                        ),
                        SizedBox(width: context.spaceSmall),
                        Expanded(
                          child: AppButton.primary(
                            label: labels?.acceptLabel ?? 'Accept',
                            onPressed: busy
                                ? null
                                : () async {
                                    final ok = await AppDialog.confirm(
                                      context,
                                      title: labels?.acceptLabel ?? 'Accept',
                                      message: 'Continue with this decision?',
                                    );
                                    if (!ok || !mounted) return;
                                    _submit(ApprovalDecision.accept);
                                  },
                          ),
                        ),
                      ],
                    )
                  else ...[
                    AppButton.primary(
                      label: labels?.acceptLabel ?? 'Accept',
                      onPressed: busy
                          ? null
                          : () async {
                              final ok = await AppDialog.confirm(
                                context,
                                title: labels?.acceptLabel ?? 'Accept',
                                message: 'Continue with this decision?',
                              );
                              if (!ok || !mounted) return;
                              _submit(ApprovalDecision.accept);
                            },
                    ),
                    SizedBox(height: context.spaceSmall),
                    AppButton.ghost(
                      label: labels?.editLabel ?? 'Edit',
                      onPressed:
                          busy || AppValidators.requiredNonEmpty(draft) != null
                          ? null
                          : () async {
                              final ok = await AppDialog.confirm(
                                context,
                                title: labels?.editLabel ?? 'Edit',
                                message: 'Send feedback and regenerate?',
                              );
                              if (!ok || !mounted) return;
                              _submit(
                                ApprovalDecision.edit,
                                editedContent: ref.read(reviewDraftTempProvider),
                              );
                            },
                    ),
                    SizedBox(height: context.spaceSmall),
                    AppButton.destructive(
                      label: labels?.rejectLabel ?? 'Reject',
                      onPressed: busy
                          ? null
                          : () async {
                              final ok = await AppDialog.confirm(
                                context,
                                title: labels?.rejectLabel ?? 'Reject',
                                message: 'Cancel this run?',
                              );
                              if (!ok || !mounted) return;
                              _submit(ApprovalDecision.reject);
                            },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
