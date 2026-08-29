import 'package:drift/drift.dart';

class ConnectorCredentials extends Table {
  TextColumn get connectorKey => text()();
  TextColumn get fieldKey => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {connectorKey, fieldKey};
}
