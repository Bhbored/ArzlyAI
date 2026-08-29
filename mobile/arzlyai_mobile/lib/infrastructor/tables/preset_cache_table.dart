import 'package:drift/drift.dart';

class PresetCache extends Table {
  TextColumn get key => text()();
  IntColumn get version => integer()();
  TextColumn get responseJson => text()();
  DateTimeColumn get fetchedAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {key, version};
}
