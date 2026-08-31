import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/services/reports/report_export_service.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/receipt_report_view.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/receipt_workflow_metadata.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class ReceiptResultScreen extends ConsumerWidget {
  const ReceiptResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runAsync = ref.watch(activeRunProvider);
    final schema = ref.watch(presetDetailsProvider).value?.inputSchema;
    final analysisMode =
        ref.watch(runConfigTempProvider).inputs['analysisMode']?.trim() ?? '';
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          analysisMode.isEmpty
              ? 'Receipt report'
              : receiptModeShortTitle(schema, analysisMode),
          style: theme.textTheme.h4,
        ),
        actions: runAsync.maybeWhen(
          data: (run) {
            if (run == null || !hasReceiptReportHtml(run)) return null;
            return [
              Padding(
                padding: EdgeInsets.only(right: context.paddingSmall),
                child: AppButton.ghost(
                  label: 'Share',
                  onPressed: () =>
                      const ReportExportService().shareRenderedHtml(
                        run.renderedResult!,
                        subject: run.report?.title,
                      ),
                ),
              ),
            ];
          },
          orElse: () => null,
        ),
      ),
      body: runAsync.when(
        data: (run) {
          if (run == null) {
            return const AppStatus.error(
              message: 'No receipt report is available.',
            );
          }
          return Padding(
            padding: EdgeInsets.all(context.paddingSmall),
            child: ReceiptReportView(run: run),
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) => AppStatus.error(message: '$error'),
      ),
    );
  }
}
