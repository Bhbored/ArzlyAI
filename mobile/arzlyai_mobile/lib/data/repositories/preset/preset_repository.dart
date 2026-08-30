import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_summary_response.dart';
import 'package:arzlyai_mobile/core/network/services/preset/preset_service.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

part 'preset_repository.g.dart';

const _catalogCacheKey = '_catalog';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
PresetRepository presetRepository(Ref ref) {
  return PresetRepository(
    ref.read(appDatabaseProvider),
    ref.read(presetServiceProvider),
    const PresetMapper(),
  );
}

class PresetRepository {
  PresetRepository(this._db, this._service, this._mapper);

  final AppDatabase _db;
  final PresetService _service;
  final PresetMapper _mapper;

  Future<List<PresetSummary>> cachedSummaries() async {
    final row = await (_db.select(
      _db.presetCache,
    )..where((t) => t.key.equals(_catalogCacheKey))).getSingleOrNull();
    if (row == null) return const [];
    final list = jsonDecode(row.responseJson) as List<dynamic>;
    return list
        .map(
          (item) => _mapper.summaryFromDto(
            PresetSummaryResponse.fromJson(item as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  Future<List<PresetSummary>> refreshSummaries() async {
    final dtos = await _service.listPresets();
    await _db
        .into(_db.presetCache)
        .insertOnConflictUpdate(
          PresetCacheCompanion.insert(
            key: _catalogCacheKey,
            version: 0,
            responseJson: jsonEncode(dtos.map((e) => e.toJson()).toList()),
            fetchedAtUtc: DateTime.now().toUtc(),
          ),
        );
    return dtos.map(_mapper.summaryFromDto).toList();
  }

  Future<PresetDetails?> cachedDetails(String key, int version) async {
    final row =
        await (_db.select(_db.presetCache)
              ..where((t) => t.key.equals(key) & t.version.equals(version)))
            .getSingleOrNull();
    if (row == null) return null;
    return _mapper.detailsFromDto(
      PresetDetailsResponse.fromJson(
        jsonDecode(row.responseJson) as Map<String, dynamic>,
      ),
    );
  }

  Future<PresetDetails> refreshDetails(String key) async {
    final dto = await _service.getPreset(key);
    await _db
        .into(_db.presetCache)
        .insertOnConflictUpdate(
          PresetCacheCompanion.insert(
            key: dto.key,
            version: dto.version,
            responseJson: jsonEncode(dto.toJson()),
            fetchedAtUtc: DateTime.now().toUtc(),
          ),
        );
    return _mapper.detailsFromDto(dto);
  }
}
