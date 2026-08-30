import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/infrastructor/tables/ai_settings_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/connector_credentials_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/preset_cache_table.dart';
import 'package:arzlyai_mobile/infrastructor/tables/provider_model_cache_table.dart';
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
    AiSettings,
    ProviderModelCache,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      final columns = await customSelect('PRAGMA table_info(schedules)').get();
      final names = columns.map((row) => row.read<String>('name')).toSet();
      if (!names.contains('recurrence_json')) {
        await customStatement(
          "ALTER TABLE schedules ADD COLUMN recurrence_json TEXT NOT NULL DEFAULT '{}'",
        );
      }
      if (!names.contains('workflow_inputs_json')) {
        await customStatement(
          "ALTER TABLE schedules ADD COLUMN workflow_inputs_json TEXT NOT NULL DEFAULT '{}'",
        );
      }
      if (!names.contains('preset_name')) {
        await customStatement(
          "ALTER TABLE schedules ADD COLUMN preset_name TEXT NOT NULL DEFAULT 'ArzlyAI'",
        );
      }
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
