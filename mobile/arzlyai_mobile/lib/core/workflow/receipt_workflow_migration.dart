import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

Future<void> migrateLegacyReceiptWorkflows(AppDatabase db) async {
  for (final legacyKey in legacyReceiptPresetKeys) {
    final mode = legacyReceiptPresetToAnalysisMode[legacyKey];
    if (mode == null) continue;
    final instances = await (db.select(
      db.workflowInstances,
    )..where((row) => row.presetKey.equals(legacyKey))).get();
    for (final instance in instances) {
      await (db.update(
        db.workflowInstances,
      )..where((row) => row.id.equals(instance.id))).write(
        WorkflowInstancesCompanion(
          presetKey: const Value(ReceiptIntelligencePreset.key),
          updatedAtUtc: Value(DateTime.now().toUtc()),
        ),
      );
      final schedule = await (db.select(
        db.schedules,
      )..where((row) => row.localWorkflowId.equals(instance.id))).getSingleOrNull();
      if (schedule == null) continue;
      final inputs =
          jsonDecode(schedule.workflowInputsJson) as Map<String, dynamic>;
      final mapped = inputs.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      if (mapped['analysisMode']?.trim().isEmpty ?? true) {
        mapped['analysisMode'] = mode;
      }
      await db.customStatement(
        '''
UPDATE schedules
SET workflow_inputs_json = ?
WHERE local_workflow_id = ?
''',
        [jsonEncode(mapped), instance.id],
      );
    }
  }
}
