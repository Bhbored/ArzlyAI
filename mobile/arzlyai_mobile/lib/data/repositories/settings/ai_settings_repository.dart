import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

part 'ai_settings_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
AiSettingsRepository aiSettingsRepository(Ref ref) {
  return AiSettingsRepository(ref.read(appDatabaseProvider));
}

class DefaultAiModel {
  const DefaultAiModel({required this.provider, required this.modelId});

  final String provider;
  final String modelId;
}

class AiSettingsRepository {
  AiSettingsRepository(this._db);

  final AppDatabase _db;

  Future<DefaultAiModel?> readDefault() async {
    final row = await (_db.select(_db.aiSettings)
          ..where((table) => table.id.equals(1)))
        .getSingleOrNull();
    if (row?.defaultProvider == null || row?.defaultModelId == null) {
      return null;
    }
    return DefaultAiModel(
      provider: row!.defaultProvider!,
      modelId: row.defaultModelId!,
    );
  }

  Future<void> saveDefault({
    required String provider,
    required String modelId,
  }) async {
    await _db.into(_db.aiSettings).insertOnConflictUpdate(
          AiSettingsCompanion.insert(
            id: const Value(1),
            defaultProvider: Value(provider),
            defaultModelId: Value(modelId),
          ),
        );
  }
}
