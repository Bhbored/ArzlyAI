import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/infrastructor/tables/connector_credentials_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/preset_cache_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/schedule_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/workflow_instance_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/workflow_node_run_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/workflow_run_table.dart';

part 'database.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@DriftDatabase(
  tables: [
    PresetCache,
    WorkflowInstances,
    WorkflowRuns,
    WorkflowNodeRuns,
    Schedules,
    ConnectorCredentials,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'arzlyai.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
