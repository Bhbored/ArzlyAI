import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/ui/features/presets/details/preset_details_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_workflow_node_screen.dart';
import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';

PresetDetails smartBuyDetails() {
  return const PresetMapper().detailsFromDto(
    PresetDetailsResponse.fromJson(
      jsonDecode(
            File(
              'test/presets/smart_purchase_decision/fixtures/preset_details.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>,
    ),
  );
}

WorkflowRunResponse requirementsWaitingRunDto() {
  return WorkflowRunResponse.fromJson(
    jsonDecode(
          File(
            'test/presets/smart_purchase_decision/fixtures/workflow_run_requirements_waiting.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>,
  );
}

class _RequirementsWaiting extends ActiveRun {
  @override
  Future<WorkflowRun?> build() async {
    return const WorkflowRunMapper().fromDto(requirementsWaitingRunDto());
  }
}

void main() {
  testWidgets('SmartBuyDetails_WhenFirstAgentTapped_OpensConfigure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          presetDetailsProvider.overrideWith(
            () => SeededDetails(smartBuyDetails()),
          ),
        ],
        child: testApp(home: const PresetDetailsScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Understand request'));
    await tester.pumpAndSettle();

    expect(find.byType(SmartPurchaseConfigureRunScreen), findsOneWidget);
    expect(find.text('What are you buying?'), findsOneWidget);
  });

  testWidgets(
    'SmartBuyDetails_WhenCompletedAgentTappedDuringRun_DoesNotOpenNodeDetails',
    (tester) async {
      final run = const WorkflowRunMapper().fromDto(requirementsWaitingRunDto());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            presetDetailsProvider.overrideWith(
              () => SeededDetails(smartBuyDetails()),
            ),
            selectedRunIdProvider.overrideWithValue(run.runId),
            activeRunProvider.overrideWith(_RequirementsWaiting.new),
          ],
          child: testApp(home: const PresetDetailsScreen()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      await tester.tap(find.text('Understand request'));
      await tester.pump();

      expect(find.byType(AppWorkflowNodeScreen), findsNothing);
      expect(find.byType(SmartPurchaseConfigureRunScreen), findsNothing);
    },
  );
}
