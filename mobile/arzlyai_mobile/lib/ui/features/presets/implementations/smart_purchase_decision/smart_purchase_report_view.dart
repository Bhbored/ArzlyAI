import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/purchase_decision_report_text.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_report_panel.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_report_webview.dart';

class SmartPurchaseReportView extends StatelessWidget {
  const SmartPurchaseReportView({
    required this.run,
    this.minWebViewHeight = 480,
    super.key,
  });

  final WorkflowRun run;
  final double minWebViewHeight;

  bool get _hasHtml =>
      run.renderedResult?.mediaType == 'text/html' &&
      (run.renderedResult?.content.trim().isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    if (_hasHtml) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.hasBoundedHeight && constraints.maxHeight > 0
              ? constraints.maxHeight
              : minWebViewHeight;
          return SizedBox(
            height: height,
            child: AppReportWebView(html: run.renderedResult!.content),
          );
        },
      );
    }
    final report = run.report;
    if (report != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (report.title.isNotEmpty)
            Text(report.title, style: theme.textTheme.h4),
          if (report.title.isNotEmpty) SizedBox(height: context.spaceMedium),
          SmartPurchaseReportPanel(report: report),
        ],
      );
    }
    final fallback = run.finalResponse ?? '';
    if (fallback.trim().isEmpty) {
      return Text(
        'No decision report available.',
        style: theme.textTheme.p,
      );
    }
    final structured = PurchaseDecisionReportText.structuredBody(
      context,
      fallback,
    );
    if (structured != null) {
      return AppCard.standard(child: structured);
    }
    return SelectableText(fallback, style: theme.textTheme.p);
  }
}

@visibleForTesting
bool shouldUseRenderedHtml(WorkflowRun run) {
  return run.renderedResult?.mediaType == 'text/html' &&
      (run.renderedResult?.content.trim().isNotEmpty ?? false);
}

@visibleForTesting
ArzlyReport? nativeReportForRun(WorkflowRun run) => run.report;
