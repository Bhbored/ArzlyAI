import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/review_screen.dart';
import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';
import 'preset_details_screen_test.dart';

WorkflowRunResponse finalReviewRunDto() {
  return WorkflowRunResponse.fromJson(
    jsonDecode(
          File(
            'test/presets/smart_purchase_decision/fixtures/workflow_run_final_waiting.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>,
  );
}

class _FinalReviewRun extends ActiveRun {
  @override
  Future<WorkflowRun?> build() async {
    final dto = finalReviewRunDto();
    const content =
        r'{"version":4,"title":"Work Laptop in Lebanon","summary":"Options under $800 in Lebanon","generatedAtUtc":"2026-08-30T17:40:13Z","sources":[{"id":"s1","title":"Acer Aspire 5 A515-46-R74Z","url":"https://lebtechlb.com/acer","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"},{"id":"s2","title":"Lenovo IdeaPad 3 14ITL6","url":"https://lebtechlb.com/lenovo","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"}]}';
    return const WorkflowRunMapper().fromDto(
      dto.copyWith(
        approval: dto.approval!.copyWith(
          originalContent: content,
          currentContent: content,
        ),
      ),
    );
  }
}

void main() {
  testWidgets('ReviewScreen_WhenFinalPickWaiting_ShowsReportNotRawJson', (
    tester,
  ) async {
    final run = await _FinalReviewRun().build();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetDetailsProvider.overrideWith(
            () => SeededDetails(smartBuyDetails()),
          ),
          selectedRunIdProvider.overrideWithValue(run!.runId),
          activeRunProvider.overrideWith(_FinalReviewRun.new),
          reviewDraftTempProvider.overrideWith(_EmptyDraft.new),
          internetConnectionProvider.overrideWithValue(true),
          offlineModeProvider.overrideWith(OnlineMode.new),
        ],
        child: testApp(home: const SmartPurchaseReviewScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Your pick'), findsOneWidget);
    expect(find.textContaining('Acer Aspire 5'), findsWidgets);
    expect(find.textContaining('"version":4'), findsNothing);
  });
}

class _EmptyDraft extends ReviewDraftTemp {
  @override
  String build() => '';
}
