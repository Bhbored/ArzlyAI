import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_outcomes.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_task_keys.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/workflow_schedule.dart';
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
    final row = await (_db.select(_db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<List<WorkflowSchedule>> listEnabled() async {
    final rows = await (_db.select(_db.schedules)
          ..where((t) => t.enabled.equals(true)))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<List<WorkflowSchedule>> listDue(DateTime nowUtc) async {
    final rows = await (_db.select(_db.schedules)
          ..where(
            (t) => t.enabled.equals(true) & t.nextRunAtUtc.isSmallerOrEqualValue(nowUtc),
          ))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<WorkflowSchedule> upsert({
    required String localWorkflowId,
    required String localTime,
    required String timeZoneId,
    required bool enabled,
    DateTime? nextRunAtUtc,
  }) async {
    final platformTaskId = ScheduleTaskKeys.platformTaskId(localWorkflowId);
    final next = nextRunAtUtc ??
        _calculator.nextOccurrenceUtc(
          localTime: localTime,
          timeZoneId: timeZoneId,
        );
    await _db.into(_db.schedules).insertOnConflictUpdate(
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
    await (_db.delete(_db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .go();
  }

  Future<bool> tryClaimOccurrence(String localWorkflowId) async {
    return _db.transaction(() async {
      final row = await (_db.select(_db.schedules)
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

      await (_db.update(_db.schedules)
            ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
          .write(
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
    final row = await (_db.select(_db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .getSingleOrNull();
    if (row == null) return;

    final next = _calculator.nextOccurrenceUtc(
      localTime: row.localTime,
      timeZoneId: row.timeZoneId,
      afterUtc: now,
    );

    await (_db.update(_db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .write(
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
    await (_db.update(_db.schedules)
          ..where((t) => t.localWorkflowId.equals(localWorkflowId)))
        .write(
      SchedulesCompanion(
        lastAttemptAtUtc: Value(now),
        lastOutcome: Value(outcome),
        failureMessage: Value(message),
      ),
    );
  }

  Future<void> updateNextRunAtUtc(String localWorkflowId, DateTime nextRunAtUtc) async {
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
