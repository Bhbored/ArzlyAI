import 'package:drift/drift.dart';

@DataClassName('WorkflowNodeRunRow')
class WorkflowNodeRuns extends Table {
  TextColumn get runId => text()();
  TextColumn get nodeId => text()();
  TextColumn get nodeKey => text()();
  TextColumn get displayName => text()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  TextColumn get output => text().nullable()();
  TextColumn get error => text().nullable()();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {runId, nodeId};
}
