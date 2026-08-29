import 'package:drift/drift.dart';

class Schedules extends Table {
  TextColumn get localWorkflowId => text()();
  TextColumn get localTime => text()();
  TextColumn get timeZoneId => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  TextColumn get platformTaskId => text().nullable()();
  DateTimeColumn get nextRunAtUtc => dateTime()();
  DateTimeColumn get lastAttemptAtUtc => dateTime().nullable()();
  DateTimeColumn get lastSucceededAtUtc => dateTime().nullable()();
  TextColumn get lastOutcome => text().nullable()();
  TextColumn get failureMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {localWorkflowId};
}
