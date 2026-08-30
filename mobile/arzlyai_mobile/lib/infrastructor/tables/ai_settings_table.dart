import 'package:drift/drift.dart';

class AiSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  TextColumn get defaultProvider => text().nullable()();

  TextColumn get defaultModelId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
