import 'package:drift/drift.dart';

@DataClassName('WorkflowInstanceRow')
class WorkflowInstances extends Table {
  TextColumn get id => text()();
  TextColumn get presetKey => text()();
  IntColumn get presetVersion => integer()();
  TextColumn get name => text()();
  TextColumn get topic => text()();
  TextColumn get modelOverridesJson => text().nullable()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
