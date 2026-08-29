import 'package:drift/drift.dart';

class Schedules extends Table {
  TextColumn get localWorkflowId => text()();
  TextColumn get localTime => text()();
  TextColumn get timeZoneId => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  TextColumn get backendScheduleStatus => text().nullable()();

  @override
  Set<Column> get primaryKey => {localWorkflowId};
}
