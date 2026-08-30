import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/services/reports/report_export_service.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_report_view.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class SmartPurchaseResultScreen extends ConsumerWidget {
  const SmartPurchaseResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runAsync = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Result', style: theme.textTheme.h4),
        actions: runAsync.maybeWhen(
          data: (run) {
            if (run == null) return null;
            final actions = _shareActions(context, run);
            if (actions.isEmpty) return null;
            return [
              Padding(
                padding: EdgeInsets.only(right: context.paddingSmall),
                child: actions.first,
              ),
            ];
          },
          orElse: () => null,
        ),
      ),
      body: runAsync.when(
        data: (run) {
          if (run == null) {
            return Center(
              child: Text(
                'No decision report available.',
                style: theme.textTheme.p,
              ),
            );
          }
          final hasHtml = run.renderedResult?.mediaType == 'text/html' &&
              (run.renderedResult?.content.trim().isNotEmpty ?? false);
          if (hasHtml) {
            return Padding(
              padding: EdgeInsets.all(context.paddingSmall),
              child: SmartPurchaseReportView(run: run),
            );
          }
          return ListView(
            padding: EdgeInsets.all(context.paddingMedium),
            children: [
              SmartPurchaseReportView(run: run),
              SizedBox(height: context.spaceLarge),
              ..._shareActions(context, run),
            ],
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) => AppStatus.error(message: '$error'),
      ),
    );
  }

  List<Widget> _shareActions(BuildContext context, WorkflowRun run) {
    final export = const ReportExportService();
    final rendered = run.renderedResult;
    if (rendered?.mediaType == 'text/html' &&
        (rendered?.content.trim().isNotEmpty ?? false)) {
      return [
        AppButton.primary(
          label: 'Share HTML',
          onPressed: () => export.shareRenderedHtml(
            rendered!,
            subject: run.report?.title,
          ),
        ),
      ];
    }
    final report = run.report;
    if (report == null) return const [];
    return [
      AppButton.primary(
        label: 'Share HTML',
        onPressed: () => export.shareHtml(report),
      ),
      SizedBox(height: context.spaceSmall),
      AppButton.ghost(
        label: 'Share PDF',
        onPressed: () => export.sharePdf(report),
      ),
    ];
  }
}
