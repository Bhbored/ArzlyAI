import 'package:arzlyai_mobile/core/workflow/brain_dump_preset_privacy.dart';
import 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';

bool isPrivateWorkflowPresetKey(String presetKey) =>
    isReceiptWorkflowKey(presetKey) || isBrainDumpWorkflowKey(presetKey);

WorkflowRun stripPrivateWorkflowRunForPersistence(WorkflowRun run) {
  if (!isPrivateWorkflowPresetKey(run.presetKey)) return run;
  return run.copyWith(
    approval: null,
    finalResponse: null,
    report: null,
    renderedResult: null,
    resultContract: null,
    nodes: [
      for (final node in run.nodes)
        node.copyWith(output: null, error: null),
    ],
  );
}
