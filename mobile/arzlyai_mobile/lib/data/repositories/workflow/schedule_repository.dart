import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_outcomes.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_task_keys.dart';
import 'package:arzlyai_mobile/core/workflow/brain_dump_preset_privacy.dart';
import 'package:arzlyai_mobile/core/workflow/receipt_preset_privacy.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/workflow_schedule.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/schedule_recurrence.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/scheduled_workflow_configuration.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

part 'schedule_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ScheduleRepository scheduleRepository(Ref ref) {
  return ScheduleRepository(
    ref.watch(appDatabaseProvider),
    const ScheduleOccurrenceCalculator(),
  );
}

class ScheduleRepository {
  ScheduleRepository(this._db, this._calculator);

  final AppDatabase _db;
  final ScheduleOccurrenceCalculator _calculator;

  Future<List<WorkflowSchedule>> listAll() async {
    final rows = await _db.select(_db.schedules).get();
    return rows.map(_fromRow).toList();
  }

  Future<WorkflowSchedule?> getByWorkflowId(String localWorkflowId) async {
    final row =
        await (_db.select(_db.schedules)
              ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
            .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<ScheduledWorkflowConfiguration?> getConfiguration(
    String localWorkflowId,
  ) async {
    final row = await _db
        .customSelect(
          '''
SELECT recurrence_json, workflow_inputs_json, preset_name
FROM schedules
WHERE local_workflow_id = ?
''',
          variables: [Variable.withString(localWorkflowId)],
        )
        .getSingleOrNull();
    if (row == null) return null;
    final recurrenceData =
        jsonDecode(row.read<String>('recurrence_json')) as Map<String, dynamic>;
    final inputsData =
        jsonDecode(row.read<String>('workflow_inputs_json'))
            as Map<String, dynamic>;
    return ScheduledWorkflowConfiguration(
      recurrence: ScheduleRecurrence.fromJson(recurrenceData),
      inputs: inputsData.map((key, value) => MapEntry(key, value.toString())),
      presetName: row.read<String>('preset_name'),
    );
  }

  Future<List<WorkflowSchedule>> listEnabled() async {
    final rows = await (_db.select(
      _db.schedules,
    )..where((t) => t.enabled.equals(true))).get();
    return rows.map(_fromRow).toList();
  }

  Future<List<WorkflowSchedule>> listDue(DateTime nowUtc) async {
    final rows =
        await (_db.select(_db.schedules)..where(
              (t) =>
                  t.enabled.equals(true) &
                  t.nextRunAtUtc.isSmallerOrEqualValue(nowUtc),
            ))
            .get();
    return rows.map(_fromRow).toList();
  }

  Future<WorkflowSchedule> upsert({
    required String localWorkflowId,
    required String localTime,
    required String timeZoneId,
    required bool enabled,
    ScheduleRecurrence? recurrence,
    Map<String, String> workflowInputs = const {},
    String presetName = 'ArzlyAI',
    DateTime? nextRunAtUtc,
  }) async {
    final rule = recurrence ?? ScheduleRecurrence.daily();
    final platformTaskId = ScheduleTaskKeys.platformTaskId(localWorkflowId);
    final next =
        nextRunAtUtc ??
        _calculator.nextOccurrenceUtc(
          localTime: localTime,
          timeZoneId: timeZoneId,
          recurrence: rule,
        );
    await _db
        .into(_db.schedules)
        .insertOnConflictUpdate(
          SchedulesCompanion.insert(
            localWorkflowId: localWorkflowId,
            localTime: localTime,
            timeZoneId: timeZoneId,
            enabled: Value(enabled),
            platformTaskId: Value(platformTaskId),
            nextRunAtUtc: next,
            lastAttemptAtUtc: const Value.absent(),
            lastSucceededAtUtc: const Value.absent(),
            lastOutcome: const Value.absent(),
            failureMessage: const Value.absent(),
          ),
        );
    await _db.customStatement(
      '''
UPDATE schedules
SET recurrence_json = ?, workflow_inputs_json = ?, preset_name = ?
WHERE local_workflow_id = ?
''',
      [
        jsonEncode(rule.toJson()),
        jsonEncode(workflowInputs),
        presetName,
        localWorkflowId,
      ],
    );
    return WorkflowSchedule(
      localWorkflowId: localWorkflowId,
      localTime: localTime,
      timeZoneId: timeZoneId,
      enabled: enabled,
      platformTaskId: platformTaskId,
      nextRunAtUtc: next,
    );
  }

  Future<void> setEnabled(String localWorkflowId, bool enabled) async {
    await (_db.update(_db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .write(SchedulesCompanion(enabled: Value(enabled)));
  }

  Future<void> delete(String localWorkflowId) async {
    await (_db.delete(
      _db.schedules,
    )..where((t) => t.localWorkflowId.equals(localWorkflowId))).go();
  }

  Future<bool> tryClaimOccurrence(String localWorkflowId) async {
    return _db.transaction(() async {
      final row =
          await (_db.select(_db.schedules)
                ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
              .getSingleOrNull();
      if (row == null || !row.enabled) return false;

      final now = DateTime.now().toUtc();
      if (row.nextRunAtUtc.isAfter(now)) return false;

      if (row.lastSucceededAtUtc != null &&
          !row.lastSucceededAtUtc!.isBefore(row.nextRunAtUtc)) {
        return false;
      }

      if (row.lastAttemptAtUtc != null &&
          !row.lastAttemptAtUtc!.isBefore(row.nextRunAtUtc) &&
          row.lastOutcome == ScheduleOutcomes.started) {
        return false;
      }

      await (_db.update(
        _db.schedules,
      )..where((t) => t.localWorkflowId.equals(localWorkflowId))).write(
        SchedulesCompanion(
          lastAttemptAtUtc: Value(now),
          lastOutcome: const Value(ScheduleOutcomes.started),
          failureMessage: const Value(null),
        ),
      );
      return true;
    });
  }

  Future<void> recordSuccess({
    required String localWorkflowId,
    required String outcome,
    DateTime? succeededAtUtc,
  }) async {
    final now = succeededAtUtc ?? DateTime.now().toUtc();
    final row =
        await (_db.select(_db.schedules)
              ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
            .getSingleOrNull();
    if (row == null) return;
    final configuration = await getConfiguration(localWorkflowId);

    final next = _calculator.nextOccurrenceUtc(
      localTime: row.localTime,
      timeZoneId: row.timeZoneId,
      recurrence: configuration?.recurrence,
      afterUtc: now,
    );

    await (_db.update(
      _db.schedules,
    )..where((t) => t.localWorkflowId.equals(localWorkflowId))).write(
      SchedulesCompanion(
        lastSucceededAtUtc: Value(now),
        lastOutcome: Value(outcome),
        failureMessage: const Value(null),
        nextRunAtUtc: Value(next),
      ),
    );
  }

  Future<void> recordFailure({
    required String localWorkflowId,
    required String message,
    String outcome = ScheduleOutcomes.failed,
  }) async {
    final now = DateTime.now().toUtc();
    final instance = await (_db.select(
      _db.workflowInstances,
    )..where((row) => row.id.equals(localWorkflowId))).getSingleOrNull();
    final persistedMessage = switch (instance?.presetKey ?? '') {
      final key when isReceiptWorkflowKey(key) =>
        'Receipt workflow could not run in the background.',
      final key when isBrainDumpWorkflowKey(key) =>
        'Brain dump workflow could not run in the background.',
      _ => message,
    };
    await (_db.update(
      _db.schedules,
    )..where((t) => t.localWorkflowId.equals(localWorkflowId))).write(
      SchedulesCompanion(
        lastAttemptAtUtc: Value(now),
        lastOutcome: Value(outcome),
        failureMessage: Value(persistedMessage),
      ),
    );
  }

  Future<void> updateNextRunAtUtc(
    String localWorkflowId,
    DateTime nextRunAtUtc,
  ) async {
    await (_db.update(_db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .write(SchedulesCompanion(nextRunAtUtc: Value(nextRunAtUtc)));
  }

  WorkflowSchedule _fromRow(Schedule row) {
    return WorkflowSchedule(
      localWorkflowId: row.localWorkflowId,
      localTime: row.localTime,
      timeZoneId: row.timeZoneId,
      enabled: row.enabled,
      platformTaskId: row.platformTaskId,
      nextRunAtUtc: row.nextRunAtUtc,
      lastAttemptAtUtc: row.lastAttemptAtUtc,
      lastSucceededAtUtc: row.lastSucceededAtUtc,
      lastOutcome: row.lastOutcome,
      failureMessage: row.failureMessage,
    );
  }
}
