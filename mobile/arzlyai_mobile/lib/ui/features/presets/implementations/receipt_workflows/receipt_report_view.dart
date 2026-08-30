import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_report_webview.dart';

class ReceiptReportView extends StatelessWidget {
  const ReceiptReportView({required this.run, super.key});

  final WorkflowRun run;

  @override
  Widget build(BuildContext context) {
    if (hasReceiptReportHtml(run)) {
      return AppReportWebView(html: run.renderedResult!.content);
    }
    final theme = ShadTheme.of(context);
    return Center(
      child: Text(
        run.finalResponse?.trim().isNotEmpty == true
            ? 'The report completed but HTML rendering is unavailable.'
            : 'No receipt report is available.',
        style: theme.textTheme.p,
        textAlign: TextAlign.center,
      ),
    );
  }
}

bool hasReceiptReportHtml(WorkflowRun run) {
  return run.renderedResult?.mediaType == 'text/html' &&
      (run.renderedResult?.content.trim().isNotEmpty ?? false);
}
