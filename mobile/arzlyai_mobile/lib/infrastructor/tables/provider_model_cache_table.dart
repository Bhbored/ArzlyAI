import 'package:drift/drift.dart';

class ProviderModelCache extends Table {
  TextColumn get provider => text()();

  TextColumn get modelsJson => text()();

  DateTimeColumn get fetchedAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {provider};
}
