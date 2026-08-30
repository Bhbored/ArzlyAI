import 'package:drift/drift.dart';

@DataClassName('WorkflowRunRow')
class WorkflowRuns extends Table {
  TextColumn get runId => text()();
  TextColumn get localWorkflowId => text()();
  TextColumn get presetKey => text()();
  TextColumn get status => text()();
  TextColumn get approvalSnapshotJson => text().nullable()();
  TextColumn get finalResponse => text().nullable()();
  TextColumn get resultDocumentJson => text().nullable()();
  TextColumn get resultContractKey => text().nullable()();
  IntColumn get resultContractVersion => integer().nullable()();
  TextColumn get renderedResultMediaType => text().nullable()();
  TextColumn get renderedResultContent => text().nullable()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime()();
  DateTimeColumn get expiryUtc => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {runId};
}
