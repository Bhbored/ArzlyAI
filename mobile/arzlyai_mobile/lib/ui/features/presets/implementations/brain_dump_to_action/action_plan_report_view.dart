import 'package:flutter/material.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_report_webview.dart';

class ActionPlanReportView extends StatelessWidget {
  const ActionPlanReportView({
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
    final fallback =
        run.finalResponse ?? run.approval?.currentContent ?? '';
    if (fallback.trim().isEmpty) {
      return const Text('No action plan available.');
    }
    return SingleChildScrollView(child: Text(fallback));
  }
}

@visibleForTesting
bool shouldUseRenderedActionPlanHtml(WorkflowRun run) {
  return run.renderedResult?.mediaType == 'text/html' &&
      (run.renderedResult?.content.trim().isNotEmpty ?? false);
}

@visibleForTesting
dynamic nativeActionPlanForRun(WorkflowRun run) {
  const mapper = ArzlyReportMapper();
  return run.report ??
      mapper.fromJsonString(run.approval?.currentContent) ??
      mapper.fromJsonString(run.finalResponse);
}
