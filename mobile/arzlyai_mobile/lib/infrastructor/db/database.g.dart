// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PresetCacheTable extends PresetCache
    with TableInfo<$PresetCacheTable, PresetCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresetCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseJsonMeta = const VerificationMeta(
    'responseJson',
  );
  @override
  late final GeneratedColumn<String> responseJson = GeneratedColumn<String>(
    'response_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtUtcMeta = const VerificationMeta(
    'fetchedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAtUtc = GeneratedColumn<DateTime>(
    'fetched_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    version,
    responseJson,
    fetchedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preset_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<PresetCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('response_json')) {
      context.handle(
        _responseJsonMeta,
        responseJson.isAcceptableOrUnknown(
          data['response_json']!,
          _responseJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responseJsonMeta);
    }
    if (data.containsKey('fetched_at_utc')) {
      context.handle(
        _fetchedAtUtcMeta,
        fetchedAtUtc.isAcceptableOrUnknown(
          data['fetched_at_utc']!,
          _fetchedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key, version};
  @override
  PresetCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PresetCacheData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      responseJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_json'],
      )!,
      fetchedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at_utc'],
      )!,
    );
  }

  @override
  $PresetCacheTable createAlias(String alias) {
    return $PresetCacheTable(attachedDatabase, alias);
  }
}

class PresetCacheData extends DataClass implements Insertable<PresetCacheData> {
  final String key;
  final int version;
  final String responseJson;
  final DateTime fetchedAtUtc;
  const PresetCacheData({
    required this.key,
    required this.version,
    required this.responseJson,
    required this.fetchedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['version'] = Variable<int>(version);
    map['response_json'] = Variable<String>(responseJson);
    map['fetched_at_utc'] = Variable<DateTime>(fetchedAtUtc);
    return map;
  }

  PresetCacheCompanion toCompanion(bool nullToAbsent) {
    return PresetCacheCompanion(
      key: Value(key),
      version: Value(version),
      responseJson: Value(responseJson),
      fetchedAtUtc: Value(fetchedAtUtc),
    );
  }

  factory PresetCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PresetCacheData(
      key: serializer.fromJson<String>(json['key']),
      version: serializer.fromJson<int>(json['version']),
      responseJson: serializer.fromJson<String>(json['responseJson']),
      fetchedAtUtc: serializer.fromJson<DateTime>(json['fetchedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'version': serializer.toJson<int>(version),
      'responseJson': serializer.toJson<String>(responseJson),
      'fetchedAtUtc': serializer.toJson<DateTime>(fetchedAtUtc),
    };
  }

  PresetCacheData copyWith({
    String? key,
    int? version,
    String? responseJson,
    DateTime? fetchedAtUtc,
  }) => PresetCacheData(
    key: key ?? this.key,
    version: version ?? this.version,
    responseJson: responseJson ?? this.responseJson,
    fetchedAtUtc: fetchedAtUtc ?? this.fetchedAtUtc,
  );
  PresetCacheData copyWithCompanion(PresetCacheCompanion data) {
    return PresetCacheData(
      key: data.key.present ? data.key.value : this.key,
      version: data.version.present ? data.version.value : this.version,
      responseJson: data.responseJson.present
          ? data.responseJson.value
          : this.responseJson,
      fetchedAtUtc: data.fetchedAtUtc.present
          ? data.fetchedAtUtc.value
          : this.fetchedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PresetCacheData(')
          ..write('key: $key, ')
          ..write('version: $version, ')
          ..write('responseJson: $responseJson, ')
          ..write('fetchedAtUtc: $fetchedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, version, responseJson, fetchedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PresetCacheData &&
          other.key == this.key &&
          other.version == this.version &&
          other.responseJson == this.responseJson &&
          other.fetchedAtUtc == this.fetchedAtUtc);
}

class PresetCacheCompanion extends UpdateCompanion<PresetCacheData> {
  final Value<String> key;
  final Value<int> version;
  final Value<String> responseJson;
  final Value<DateTime> fetchedAtUtc;
  final Value<int> rowid;
  const PresetCacheCompanion({
    this.key = const Value.absent(),
    this.version = const Value.absent(),
    this.responseJson = const Value.absent(),
    this.fetchedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresetCacheCompanion.insert({
    required String key,
    required int version,
    required String responseJson,
    required DateTime fetchedAtUtc,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       version = Value(version),
       responseJson = Value(responseJson),
       fetchedAtUtc = Value(fetchedAtUtc);
  static Insertable<PresetCacheData> custom({
    Expression<String>? key,
    Expression<int>? version,
    Expression<String>? responseJson,
    Expression<DateTime>? fetchedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (version != null) 'version': version,
      if (responseJson != null) 'response_json': responseJson,
      if (fetchedAtUtc != null) 'fetched_at_utc': fetchedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresetCacheCompanion copyWith({
    Value<String>? key,
    Value<int>? version,
    Value<String>? responseJson,
    Value<DateTime>? fetchedAtUtc,
    Value<int>? rowid,
  }) {
    return PresetCacheCompanion(
      key: key ?? this.key,
      version: version ?? this.version,
      responseJson: responseJson ?? this.responseJson,
      fetchedAtUtc: fetchedAtUtc ?? this.fetchedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (responseJson.present) {
      map['response_json'] = Variable<String>(responseJson.value);
    }
    if (fetchedAtUtc.present) {
      map['fetched_at_utc'] = Variable<DateTime>(fetchedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresetCacheCompanion(')
          ..write('key: $key, ')
          ..write('version: $version, ')
          ..write('responseJson: $responseJson, ')
          ..write('fetchedAtUtc: $fetchedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkflowInstancesTable extends WorkflowInstances
    with TableInfo<$WorkflowInstancesTable, WorkflowInstanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkflowInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presetKeyMeta = const VerificationMeta(
    'presetKey',
  );
  @override
  late final GeneratedColumn<String> presetKey = GeneratedColumn<String>(
    'preset_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presetVersionMeta = const VerificationMeta(
    'presetVersion',
  );
  @override
  late final GeneratedColumn<int> presetVersion = GeneratedColumn<int>(
    'preset_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelOverridesJsonMeta =
      const VerificationMeta('modelOverridesJson');
  @override
  late final GeneratedColumn<String> modelOverridesJson =
      GeneratedColumn<String>(
        'model_overrides_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    presetKey,
    presetVersion,
    name,
    topic,
    modelOverridesJson,
    createdAtUtc,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workflow_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkflowInstanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('preset_key')) {
      context.handle(
        _presetKeyMeta,
        presetKey.isAcceptableOrUnknown(data['preset_key']!, _presetKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_presetKeyMeta);
    }
    if (data.containsKey('preset_version')) {
      context.handle(
        _presetVersionMeta,
        presetVersion.isAcceptableOrUnknown(
          data['preset_version']!,
          _presetVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_presetVersionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('model_overrides_json')) {
      context.handle(
        _modelOverridesJsonMeta,
        modelOverridesJson.isAcceptableOrUnknown(
          data['model_overrides_json']!,
          _modelOverridesJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkflowInstanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkflowInstanceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      presetKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preset_key'],
      )!,
      presetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preset_version'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      modelOverridesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_overrides_json'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $WorkflowInstancesTable createAlias(String alias) {
    return $WorkflowInstancesTable(attachedDatabase, alias);
  }
}

class WorkflowInstanceRow extends DataClass
    implements Insertable<WorkflowInstanceRow> {
  final String id;
  final String presetKey;
  final int presetVersion;
  final String name;
  final String topic;
  final String? modelOverridesJson;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  const WorkflowInstanceRow({
    required this.id,
    required this.presetKey,
    required this.presetVersion,
    required this.name,
    required this.topic,
    this.modelOverridesJson,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['preset_key'] = Variable<String>(presetKey);
    map['preset_version'] = Variable<int>(presetVersion);
    map['name'] = Variable<String>(name);
    map['topic'] = Variable<String>(topic);
    if (!nullToAbsent || modelOverridesJson != null) {
      map['model_overrides_json'] = Variable<String>(modelOverridesJson);
    }
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  WorkflowInstancesCompanion toCompanion(bool nullToAbsent) {
    return WorkflowInstancesCompanion(
      id: Value(id),
      presetKey: Value(presetKey),
      presetVersion: Value(presetVersion),
      name: Value(name),
      topic: Value(topic),
      modelOverridesJson: modelOverridesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(modelOverridesJson),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory WorkflowInstanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkflowInstanceRow(
      id: serializer.fromJson<String>(json['id']),
      presetKey: serializer.fromJson<String>(json['presetKey']),
      presetVersion: serializer.fromJson<int>(json['presetVersion']),
      name: serializer.fromJson<String>(json['name']),
      topic: serializer.fromJson<String>(json['topic']),
      modelOverridesJson: serializer.fromJson<String?>(
        json['modelOverridesJson'],
      ),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'presetKey': serializer.toJson<String>(presetKey),
      'presetVersion': serializer.toJson<int>(presetVersion),
      'name': serializer.toJson<String>(name),
      'topic': serializer.toJson<String>(topic),
      'modelOverridesJson': serializer.toJson<String?>(modelOverridesJson),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  WorkflowInstanceRow copyWith({
    String? id,
    String? presetKey,
    int? presetVersion,
    String? name,
    String? topic,
    Value<String?> modelOverridesJson = const Value.absent(),
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
  }) => WorkflowInstanceRow(
    id: id ?? this.id,
    presetKey: presetKey ?? this.presetKey,
    presetVersion: presetVersion ?? this.presetVersion,
    name: name ?? this.name,
    topic: topic ?? this.topic,
    modelOverridesJson: modelOverridesJson.present
        ? modelOverridesJson.value
        : this.modelOverridesJson,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  WorkflowInstanceRow copyWithCompanion(WorkflowInstancesCompanion data) {
    return WorkflowInstanceRow(
      id: data.id.present ? data.id.value : this.id,
      presetKey: data.presetKey.present ? data.presetKey.value : this.presetKey,
      presetVersion: data.presetVersion.present
          ? data.presetVersion.value
          : this.presetVersion,
      name: data.name.present ? data.name.value : this.name,
      topic: data.topic.present ? data.topic.value : this.topic,
      modelOverridesJson: data.modelOverridesJson.present
          ? data.modelOverridesJson.value
          : this.modelOverridesJson,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkflowInstanceRow(')
          ..write('id: $id, ')
          ..write('presetKey: $presetKey, ')
          ..write('presetVersion: $presetVersion, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('modelOverridesJson: $modelOverridesJson, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    presetKey,
    presetVersion,
    name,
    topic,
    modelOverridesJson,
    createdAtUtc,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkflowInstanceRow &&
          other.id == this.id &&
          other.presetKey == this.presetKey &&
          other.presetVersion == this.presetVersion &&
          other.name == this.name &&
          other.topic == this.topic &&
          other.modelOverridesJson == this.modelOverridesJson &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class WorkflowInstancesCompanion extends UpdateCompanion<WorkflowInstanceRow> {
  final Value<String> id;
  final Value<String> presetKey;
  final Value<int> presetVersion;
  final Value<String> name;
  final Value<String> topic;
  final Value<String?> modelOverridesJson;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const WorkflowInstancesCompanion({
    this.id = const Value.absent(),
    this.presetKey = const Value.absent(),
    this.presetVersion = const Value.absent(),
    this.name = const Value.absent(),
    this.topic = const Value.absent(),
    this.modelOverridesJson = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkflowInstancesCompanion.insert({
    required String id,
    required String presetKey,
    required int presetVersion,
    required String name,
    required String topic,
    this.modelOverridesJson = const Value.absent(),
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       presetKey = Value(presetKey),
       presetVersion = Value(presetVersion),
       name = Value(name),
       topic = Value(topic),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<WorkflowInstanceRow> custom({
    Expression<String>? id,
    Expression<String>? presetKey,
    Expression<int>? presetVersion,
    Expression<String>? name,
    Expression<String>? topic,
    Expression<String>? modelOverridesJson,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (presetKey != null) 'preset_key': presetKey,
      if (presetVersion != null) 'preset_version': presetVersion,
      if (name != null) 'name': name,
      if (topic != null) 'topic': topic,
      if (modelOverridesJson != null)
        'model_overrides_json': modelOverridesJson,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkflowInstancesCompanion copyWith({
    Value<String>? id,
    Value<String>? presetKey,
    Value<int>? presetVersion,
    Value<String>? name,
    Value<String>? topic,
    Value<String?>? modelOverridesJson,
    Value<DateTime>? createdAtUtc,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return WorkflowInstancesCompanion(
      id: id ?? this.id,
      presetKey: presetKey ?? this.presetKey,
      presetVersion: presetVersion ?? this.presetVersion,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      modelOverridesJson: modelOverridesJson ?? this.modelOverridesJson,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (presetKey.present) {
      map['preset_key'] = Variable<String>(presetKey.value);
    }
    if (presetVersion.present) {
      map['preset_version'] = Variable<int>(presetVersion.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (modelOverridesJson.present) {
      map['model_overrides_json'] = Variable<String>(modelOverridesJson.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkflowInstancesCompanion(')
          ..write('id: $id, ')
          ..write('presetKey: $presetKey, ')
          ..write('presetVersion: $presetVersion, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('modelOverridesJson: $modelOverridesJson, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkflowRunsTable extends WorkflowRuns
    with TableInfo<$WorkflowRunsTable, WorkflowRunRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkflowRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
    'run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localWorkflowIdMeta = const VerificationMeta(
    'localWorkflowId',
  );
  @override
  late final GeneratedColumn<String> localWorkflowId = GeneratedColumn<String>(
    'local_workflow_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presetKeyMeta = const VerificationMeta(
    'presetKey',
  );
  @override
  late final GeneratedColumn<String> presetKey = GeneratedColumn<String>(
    'preset_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approvalSnapshotJsonMeta =
      const VerificationMeta('approvalSnapshotJson');
  @override
  late final GeneratedColumn<String> approvalSnapshotJson =
      GeneratedColumn<String>(
        'approval_snapshot_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _finalResponseMeta = const VerificationMeta(
    'finalResponse',
  );
  @override
  late final GeneratedColumn<String> finalResponse = GeneratedColumn<String>(
    'final_response',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryUtcMeta = const VerificationMeta(
    'expiryUtc',
  );
  @override
  late final GeneratedColumn<DateTime> expiryUtc = GeneratedColumn<DateTime>(
    'expiry_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    runId,
    localWorkflowId,
    presetKey,
    status,
    approvalSnapshotJson,
    finalResponse,
    createdAtUtc,
    updatedAtUtc,
    expiryUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workflow_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkflowRunRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('run_id')) {
      context.handle(
        _runIdMeta,
        runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta),
      );
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('local_workflow_id')) {
      context.handle(
        _localWorkflowIdMeta,
        localWorkflowId.isAcceptableOrUnknown(
          data['local_workflow_id']!,
          _localWorkflowIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localWorkflowIdMeta);
    }
    if (data.containsKey('preset_key')) {
      context.handle(
        _presetKeyMeta,
        presetKey.isAcceptableOrUnknown(data['preset_key']!, _presetKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_presetKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('approval_snapshot_json')) {
      context.handle(
        _approvalSnapshotJsonMeta,
        approvalSnapshotJson.isAcceptableOrUnknown(
          data['approval_snapshot_json']!,
          _approvalSnapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('final_response')) {
      context.handle(
        _finalResponseMeta,
        finalResponse.isAcceptableOrUnknown(
          data['final_response']!,
          _finalResponseMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('expiry_utc')) {
      context.handle(
        _expiryUtcMeta,
        expiryUtc.isAcceptableOrUnknown(data['expiry_utc']!, _expiryUtcMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {runId};
  @override
  WorkflowRunRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkflowRunRow(
      runId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}run_id'],
      )!,
      localWorkflowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_workflow_id'],
      )!,
      presetKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preset_key'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      approvalSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approval_snapshot_json'],
      ),
      finalResponse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}final_response'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      expiryUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_utc'],
      ),
    );
  }

  @override
  $WorkflowRunsTable createAlias(String alias) {
    return $WorkflowRunsTable(attachedDatabase, alias);
  }
}

class WorkflowRunRow extends DataClass implements Insertable<WorkflowRunRow> {
  final String runId;
  final String localWorkflowId;
  final String presetKey;
  final String status;
  final String? approvalSnapshotJson;
  final String? finalResponse;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final DateTime? expiryUtc;
  const WorkflowRunRow({
    required this.runId,
    required this.localWorkflowId,
    required this.presetKey,
    required this.status,
    this.approvalSnapshotJson,
    this.finalResponse,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.expiryUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['run_id'] = Variable<String>(runId);
    map['local_workflow_id'] = Variable<String>(localWorkflowId);
    map['preset_key'] = Variable<String>(presetKey);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || approvalSnapshotJson != null) {
      map['approval_snapshot_json'] = Variable<String>(approvalSnapshotJson);
    }
    if (!nullToAbsent || finalResponse != null) {
      map['final_response'] = Variable<String>(finalResponse);
    }
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    if (!nullToAbsent || expiryUtc != null) {
      map['expiry_utc'] = Variable<DateTime>(expiryUtc);
    }
    return map;
  }

  WorkflowRunsCompanion toCompanion(bool nullToAbsent) {
    return WorkflowRunsCompanion(
      runId: Value(runId),
      localWorkflowId: Value(localWorkflowId),
      presetKey: Value(presetKey),
      status: Value(status),
      approvalSnapshotJson: approvalSnapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(approvalSnapshotJson),
      finalResponse: finalResponse == null && nullToAbsent
          ? const Value.absent()
          : Value(finalResponse),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      expiryUtc: expiryUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryUtc),
    );
  }

  factory WorkflowRunRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkflowRunRow(
      runId: serializer.fromJson<String>(json['runId']),
      localWorkflowId: serializer.fromJson<String>(json['localWorkflowId']),
      presetKey: serializer.fromJson<String>(json['presetKey']),
      status: serializer.fromJson<String>(json['status']),
      approvalSnapshotJson: serializer.fromJson<String?>(
        json['approvalSnapshotJson'],
      ),
      finalResponse: serializer.fromJson<String?>(json['finalResponse']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      expiryUtc: serializer.fromJson<DateTime?>(json['expiryUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'runId': serializer.toJson<String>(runId),
      'localWorkflowId': serializer.toJson<String>(localWorkflowId),
      'presetKey': serializer.toJson<String>(presetKey),
      'status': serializer.toJson<String>(status),
      'approvalSnapshotJson': serializer.toJson<String?>(approvalSnapshotJson),
      'finalResponse': serializer.toJson<String?>(finalResponse),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'expiryUtc': serializer.toJson<DateTime?>(expiryUtc),
    };
  }

  WorkflowRunRow copyWith({
    String? runId,
    String? localWorkflowId,
    String? presetKey,
    String? status,
    Value<String?> approvalSnapshotJson = const Value.absent(),
    Value<String?> finalResponse = const Value.absent(),
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    Value<DateTime?> expiryUtc = const Value.absent(),
  }) => WorkflowRunRow(
    runId: runId ?? this.runId,
    localWorkflowId: localWorkflowId ?? this.localWorkflowId,
    presetKey: presetKey ?? this.presetKey,
    status: status ?? this.status,
    approvalSnapshotJson: approvalSnapshotJson.present
        ? approvalSnapshotJson.value
        : this.approvalSnapshotJson,
    finalResponse: finalResponse.present
        ? finalResponse.value
        : this.finalResponse,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    expiryUtc: expiryUtc.present ? expiryUtc.value : this.expiryUtc,
  );
  WorkflowRunRow copyWithCompanion(WorkflowRunsCompanion data) {
    return WorkflowRunRow(
      runId: data.runId.present ? data.runId.value : this.runId,
      localWorkflowId: data.localWorkflowId.present
          ? data.localWorkflowId.value
          : this.localWorkflowId,
      presetKey: data.presetKey.present ? data.presetKey.value : this.presetKey,
      status: data.status.present ? data.status.value : this.status,
      approvalSnapshotJson: data.approvalSnapshotJson.present
          ? data.approvalSnapshotJson.value
          : this.approvalSnapshotJson,
      finalResponse: data.finalResponse.present
          ? data.finalResponse.value
          : this.finalResponse,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      expiryUtc: data.expiryUtc.present ? data.expiryUtc.value : this.expiryUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkflowRunRow(')
          ..write('runId: $runId, ')
          ..write('localWorkflowId: $localWorkflowId, ')
          ..write('presetKey: $presetKey, ')
          ..write('status: $status, ')
          ..write('approvalSnapshotJson: $approvalSnapshotJson, ')
          ..write('finalResponse: $finalResponse, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('expiryUtc: $expiryUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    runId,
    localWorkflowId,
    presetKey,
    status,
    approvalSnapshotJson,
    finalResponse,
    createdAtUtc,
    updatedAtUtc,
    expiryUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkflowRunRow &&
          other.runId == this.runId &&
          other.localWorkflowId == this.localWorkflowId &&
          other.presetKey == this.presetKey &&
          other.status == this.status &&
          other.approvalSnapshotJson == this.approvalSnapshotJson &&
          other.finalResponse == this.finalResponse &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.expiryUtc == this.expiryUtc);
}

class WorkflowRunsCompanion extends UpdateCompanion<WorkflowRunRow> {
  final Value<String> runId;
  final Value<String> localWorkflowId;
  final Value<String> presetKey;
  final Value<String> status;
  final Value<String?> approvalSnapshotJson;
  final Value<String?> finalResponse;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<DateTime?> expiryUtc;
  final Value<int> rowid;
  const WorkflowRunsCompanion({
    this.runId = const Value.absent(),
    this.localWorkflowId = const Value.absent(),
    this.presetKey = const Value.absent(),
    this.status = const Value.absent(),
    this.approvalSnapshotJson = const Value.absent(),
    this.finalResponse = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.expiryUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkflowRunsCompanion.insert({
    required String runId,
    required String localWorkflowId,
    required String presetKey,
    required String status,
    this.approvalSnapshotJson = const Value.absent(),
    this.finalResponse = const Value.absent(),
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    this.expiryUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : runId = Value(runId),
       localWorkflowId = Value(localWorkflowId),
       presetKey = Value(presetKey),
       status = Value(status),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<WorkflowRunRow> custom({
    Expression<String>? runId,
    Expression<String>? localWorkflowId,
    Expression<String>? presetKey,
    Expression<String>? status,
    Expression<String>? approvalSnapshotJson,
    Expression<String>? finalResponse,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<DateTime>? expiryUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (runId != null) 'run_id': runId,
      if (localWorkflowId != null) 'local_workflow_id': localWorkflowId,
      if (presetKey != null) 'preset_key': presetKey,
      if (status != null) 'status': status,
      if (approvalSnapshotJson != null)
        'approval_snapshot_json': approvalSnapshotJson,
      if (finalResponse != null) 'final_response': finalResponse,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (expiryUtc != null) 'expiry_utc': expiryUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkflowRunsCompanion copyWith({
    Value<String>? runId,
    Value<String>? localWorkflowId,
    Value<String>? presetKey,
    Value<String>? status,
    Value<String?>? approvalSnapshotJson,
    Value<String?>? finalResponse,
    Value<DateTime>? createdAtUtc,
    Value<DateTime>? updatedAtUtc,
    Value<DateTime?>? expiryUtc,
    Value<int>? rowid,
  }) {
    return WorkflowRunsCompanion(
      runId: runId ?? this.runId,
      localWorkflowId: localWorkflowId ?? this.localWorkflowId,
      presetKey: presetKey ?? this.presetKey,
      status: status ?? this.status,
      approvalSnapshotJson: approvalSnapshotJson ?? this.approvalSnapshotJson,
      finalResponse: finalResponse ?? this.finalResponse,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      expiryUtc: expiryUtc ?? this.expiryUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (localWorkflowId.present) {
      map['local_workflow_id'] = Variable<String>(localWorkflowId.value);
    }
    if (presetKey.present) {
      map['preset_key'] = Variable<String>(presetKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (approvalSnapshotJson.present) {
      map['approval_snapshot_json'] = Variable<String>(
        approvalSnapshotJson.value,
      );
    }
    if (finalResponse.present) {
      map['final_response'] = Variable<String>(finalResponse.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (expiryUtc.present) {
      map['expiry_utc'] = Variable<DateTime>(expiryUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkflowRunsCompanion(')
          ..write('runId: $runId, ')
          ..write('localWorkflowId: $localWorkflowId, ')
          ..write('presetKey: $presetKey, ')
          ..write('status: $status, ')
          ..write('approvalSnapshotJson: $approvalSnapshotJson, ')
          ..write('finalResponse: $finalResponse, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('expiryUtc: $expiryUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkflowNodeRunsTable extends WorkflowNodeRuns
    with TableInfo<$WorkflowNodeRunsTable, WorkflowNodeRunRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkflowNodeRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
    'run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeKeyMeta = const VerificationMeta(
    'nodeKey',
  );
  @override
  late final GeneratedColumn<String> nodeKey = GeneratedColumn<String>(
    'node_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputMeta = const VerificationMeta('output');
  @override
  late final GeneratedColumn<String> output = GeneratedColumn<String>(
    'output',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    runId,
    nodeId,
    nodeKey,
    displayName,
    type,
    status,
    output,
    error,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workflow_node_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkflowNodeRunRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('run_id')) {
      context.handle(
        _runIdMeta,
        runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta),
      );
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('node_key')) {
      context.handle(
        _nodeKeyMeta,
        nodeKey.isAcceptableOrUnknown(data['node_key']!, _nodeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('output')) {
      context.handle(
        _outputMeta,
        output.isAcceptableOrUnknown(data['output']!, _outputMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {runId, nodeId};
  @override
  WorkflowNodeRunRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkflowNodeRunRow(
      runId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}run_id'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      nodeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_key'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      output: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $WorkflowNodeRunsTable createAlias(String alias) {
    return $WorkflowNodeRunsTable(attachedDatabase, alias);
  }
}

class WorkflowNodeRunRow extends DataClass
    implements Insertable<WorkflowNodeRunRow> {
  final String runId;
  final String nodeId;
  final String nodeKey;
  final String displayName;
  final String type;
  final String status;
  final String? output;
  final String? error;
  final DateTime updatedAtUtc;
  const WorkflowNodeRunRow({
    required this.runId,
    required this.nodeId,
    required this.nodeKey,
    required this.displayName,
    required this.type,
    required this.status,
    this.output,
    this.error,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['run_id'] = Variable<String>(runId);
    map['node_id'] = Variable<String>(nodeId);
    map['node_key'] = Variable<String>(nodeKey);
    map['display_name'] = Variable<String>(displayName);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || output != null) {
      map['output'] = Variable<String>(output);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  WorkflowNodeRunsCompanion toCompanion(bool nullToAbsent) {
    return WorkflowNodeRunsCompanion(
      runId: Value(runId),
      nodeId: Value(nodeId),
      nodeKey: Value(nodeKey),
      displayName: Value(displayName),
      type: Value(type),
      status: Value(status),
      output: output == null && nullToAbsent
          ? const Value.absent()
          : Value(output),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory WorkflowNodeRunRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkflowNodeRunRow(
      runId: serializer.fromJson<String>(json['runId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      nodeKey: serializer.fromJson<String>(json['nodeKey']),
      displayName: serializer.fromJson<String>(json['displayName']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      output: serializer.fromJson<String?>(json['output']),
      error: serializer.fromJson<String?>(json['error']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'runId': serializer.toJson<String>(runId),
      'nodeId': serializer.toJson<String>(nodeId),
      'nodeKey': serializer.toJson<String>(nodeKey),
      'displayName': serializer.toJson<String>(displayName),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'output': serializer.toJson<String?>(output),
      'error': serializer.toJson<String?>(error),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  WorkflowNodeRunRow copyWith({
    String? runId,
    String? nodeId,
    String? nodeKey,
    String? displayName,
    String? type,
    String? status,
    Value<String?> output = const Value.absent(),
    Value<String?> error = const Value.absent(),
    DateTime? updatedAtUtc,
  }) => WorkflowNodeRunRow(
    runId: runId ?? this.runId,
    nodeId: nodeId ?? this.nodeId,
    nodeKey: nodeKey ?? this.nodeKey,
    displayName: displayName ?? this.displayName,
    type: type ?? this.type,
    status: status ?? this.status,
    output: output.present ? output.value : this.output,
    error: error.present ? error.value : this.error,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  WorkflowNodeRunRow copyWithCompanion(WorkflowNodeRunsCompanion data) {
    return WorkflowNodeRunRow(
      runId: data.runId.present ? data.runId.value : this.runId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      nodeKey: data.nodeKey.present ? data.nodeKey.value : this.nodeKey,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      output: data.output.present ? data.output.value : this.output,
      error: data.error.present ? data.error.value : this.error,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkflowNodeRunRow(')
          ..write('runId: $runId, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeKey: $nodeKey, ')
          ..write('displayName: $displayName, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('output: $output, ')
          ..write('error: $error, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    runId,
    nodeId,
    nodeKey,
    displayName,
    type,
    status,
    output,
    error,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkflowNodeRunRow &&
          other.runId == this.runId &&
          other.nodeId == this.nodeId &&
          other.nodeKey == this.nodeKey &&
          other.displayName == this.displayName &&
          other.type == this.type &&
          other.status == this.status &&
          other.output == this.output &&
          other.error == this.error &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class WorkflowNodeRunsCompanion extends UpdateCompanion<WorkflowNodeRunRow> {
  final Value<String> runId;
  final Value<String> nodeId;
  final Value<String> nodeKey;
  final Value<String> displayName;
  final Value<String> type;
  final Value<String> status;
  final Value<String?> output;
  final Value<String?> error;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const WorkflowNodeRunsCompanion({
    this.runId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.output = const Value.absent(),
    this.error = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkflowNodeRunsCompanion.insert({
    required String runId,
    required String nodeId,
    required String nodeKey,
    required String displayName,
    required String type,
    required String status,
    this.output = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : runId = Value(runId),
       nodeId = Value(nodeId),
       nodeKey = Value(nodeKey),
       displayName = Value(displayName),
       type = Value(type),
       status = Value(status),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<WorkflowNodeRunRow> custom({
    Expression<String>? runId,
    Expression<String>? nodeId,
    Expression<String>? nodeKey,
    Expression<String>? displayName,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? output,
    Expression<String>? error,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (runId != null) 'run_id': runId,
      if (nodeId != null) 'node_id': nodeId,
      if (nodeKey != null) 'node_key': nodeKey,
      if (displayName != null) 'display_name': displayName,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (output != null) 'output': output,
      if (error != null) 'error': error,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkflowNodeRunsCompanion copyWith({
    Value<String>? runId,
    Value<String>? nodeId,
    Value<String>? nodeKey,
    Value<String>? displayName,
    Value<String>? type,
    Value<String>? status,
    Value<String?>? output,
    Value<String?>? error,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return WorkflowNodeRunsCompanion(
      runId: runId ?? this.runId,
      nodeId: nodeId ?? this.nodeId,
      nodeKey: nodeKey ?? this.nodeKey,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      status: status ?? this.status,
      output: output ?? this.output,
      error: error ?? this.error,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (nodeKey.present) {
      map['node_key'] = Variable<String>(nodeKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (output.present) {
      map['output'] = Variable<String>(output.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkflowNodeRunsCompanion(')
          ..write('runId: $runId, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeKey: $nodeKey, ')
          ..write('displayName: $displayName, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('output: $output, ')
          ..write('error: $error, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, Schedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localWorkflowIdMeta = const VerificationMeta(
    'localWorkflowId',
  );
  @override
  late final GeneratedColumn<String> localWorkflowId = GeneratedColumn<String>(
    'local_workflow_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTimeMeta = const VerificationMeta(
    'localTime',
  );
  @override
  late final GeneratedColumn<String> localTime = GeneratedColumn<String>(
    'local_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeZoneIdMeta = const VerificationMeta(
    'timeZoneId',
  );
  @override
  late final GeneratedColumn<String> timeZoneId = GeneratedColumn<String>(
    'time_zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _platformTaskIdMeta = const VerificationMeta(
    'platformTaskId',
  );
  @override
  late final GeneratedColumn<String> platformTaskId = GeneratedColumn<String>(
    'platform_task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextRunAtUtcMeta = const VerificationMeta(
    'nextRunAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> nextRunAtUtc = GeneratedColumn<DateTime>(
    'next_run_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAttemptAtUtcMeta = const VerificationMeta(
    'lastAttemptAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAtUtc =
      GeneratedColumn<DateTime>(
        'last_attempt_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSucceededAtUtcMeta =
      const VerificationMeta('lastSucceededAtUtc');
  @override
  late final GeneratedColumn<DateTime> lastSucceededAtUtc =
      GeneratedColumn<DateTime>(
        'last_succeeded_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastOutcomeMeta = const VerificationMeta(
    'lastOutcome',
  );
  @override
  late final GeneratedColumn<String> lastOutcome = GeneratedColumn<String>(
    'last_outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _failureMessageMeta = const VerificationMeta(
    'failureMessage',
  );
  @override
  late final GeneratedColumn<String> failureMessage = GeneratedColumn<String>(
    'failure_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localWorkflowId,
    localTime,
    timeZoneId,
    enabled,
    platformTaskId,
    nextRunAtUtc,
    lastAttemptAtUtc,
    lastSucceededAtUtc,
    lastOutcome,
    failureMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<Schedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_workflow_id')) {
      context.handle(
        _localWorkflowIdMeta,
        localWorkflowId.isAcceptableOrUnknown(
          data['local_workflow_id']!,
          _localWorkflowIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localWorkflowIdMeta);
    }
    if (data.containsKey('local_time')) {
      context.handle(
        _localTimeMeta,
        localTime.isAcceptableOrUnknown(data['local_time']!, _localTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_localTimeMeta);
    }
    if (data.containsKey('time_zone_id')) {
      context.handle(
        _timeZoneIdMeta,
        timeZoneId.isAcceptableOrUnknown(
          data['time_zone_id']!,
          _timeZoneIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeZoneIdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('platform_task_id')) {
      context.handle(
        _platformTaskIdMeta,
        platformTaskId.isAcceptableOrUnknown(
          data['platform_task_id']!,
          _platformTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('next_run_at_utc')) {
      context.handle(
        _nextRunAtUtcMeta,
        nextRunAtUtc.isAcceptableOrUnknown(
          data['next_run_at_utc']!,
          _nextRunAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextRunAtUtcMeta);
    }
    if (data.containsKey('last_attempt_at_utc')) {
      context.handle(
        _lastAttemptAtUtcMeta,
        lastAttemptAtUtc.isAcceptableOrUnknown(
          data['last_attempt_at_utc']!,
          _lastAttemptAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_succeeded_at_utc')) {
      context.handle(
        _lastSucceededAtUtcMeta,
        lastSucceededAtUtc.isAcceptableOrUnknown(
          data['last_succeeded_at_utc']!,
          _lastSucceededAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_outcome')) {
      context.handle(
        _lastOutcomeMeta,
        lastOutcome.isAcceptableOrUnknown(
          data['last_outcome']!,
          _lastOutcomeMeta,
        ),
      );
    }
    if (data.containsKey('failure_message')) {
      context.handle(
        _failureMessageMeta,
        failureMessage.isAcceptableOrUnknown(
          data['failure_message']!,
          _failureMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localWorkflowId};
  @override
  Schedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Schedule(
      localWorkflowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_workflow_id'],
      )!,
      localTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_time'],
      )!,
      timeZoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      platformTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_task_id'],
      ),
      nextRunAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_run_at_utc'],
      )!,
      lastAttemptAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at_utc'],
      ),
      lastSucceededAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_succeeded_at_utc'],
      ),
      lastOutcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_outcome'],
      ),
      failureMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure_message'],
      ),
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }
}

class Schedule extends DataClass implements Insertable<Schedule> {
  final String localWorkflowId;
  final String localTime;
  final String timeZoneId;
  final bool enabled;
  final String? platformTaskId;
  final DateTime nextRunAtUtc;
  final DateTime? lastAttemptAtUtc;
  final DateTime? lastSucceededAtUtc;
  final String? lastOutcome;
  final String? failureMessage;
  const Schedule({
    required this.localWorkflowId,
    required this.localTime,
    required this.timeZoneId,
    required this.enabled,
    this.platformTaskId,
    required this.nextRunAtUtc,
    this.lastAttemptAtUtc,
    this.lastSucceededAtUtc,
    this.lastOutcome,
    this.failureMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_workflow_id'] = Variable<String>(localWorkflowId);
    map['local_time'] = Variable<String>(localTime);
    map['time_zone_id'] = Variable<String>(timeZoneId);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || platformTaskId != null) {
      map['platform_task_id'] = Variable<String>(platformTaskId);
    }
    map['next_run_at_utc'] = Variable<DateTime>(nextRunAtUtc);
    if (!nullToAbsent || lastAttemptAtUtc != null) {
      map['last_attempt_at_utc'] = Variable<DateTime>(lastAttemptAtUtc);
    }
    if (!nullToAbsent || lastSucceededAtUtc != null) {
      map['last_succeeded_at_utc'] = Variable<DateTime>(lastSucceededAtUtc);
    }
    if (!nullToAbsent || lastOutcome != null) {
      map['last_outcome'] = Variable<String>(lastOutcome);
    }
    if (!nullToAbsent || failureMessage != null) {
      map['failure_message'] = Variable<String>(failureMessage);
    }
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      localWorkflowId: Value(localWorkflowId),
      localTime: Value(localTime),
      timeZoneId: Value(timeZoneId),
      enabled: Value(enabled),
      platformTaskId: platformTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformTaskId),
      nextRunAtUtc: Value(nextRunAtUtc),
      lastAttemptAtUtc: lastAttemptAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAtUtc),
      lastSucceededAtUtc: lastSucceededAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSucceededAtUtc),
      lastOutcome: lastOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOutcome),
      failureMessage: failureMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(failureMessage),
    );
  }

  factory Schedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Schedule(
      localWorkflowId: serializer.fromJson<String>(json['localWorkflowId']),
      localTime: serializer.fromJson<String>(json['localTime']),
      timeZoneId: serializer.fromJson<String>(json['timeZoneId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      platformTaskId: serializer.fromJson<String?>(json['platformTaskId']),
      nextRunAtUtc: serializer.fromJson<DateTime>(json['nextRunAtUtc']),
      lastAttemptAtUtc: serializer.fromJson<DateTime?>(
        json['lastAttemptAtUtc'],
      ),
      lastSucceededAtUtc: serializer.fromJson<DateTime?>(
        json['lastSucceededAtUtc'],
      ),
      lastOutcome: serializer.fromJson<String?>(json['lastOutcome']),
      failureMessage: serializer.fromJson<String?>(json['failureMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localWorkflowId': serializer.toJson<String>(localWorkflowId),
      'localTime': serializer.toJson<String>(localTime),
      'timeZoneId': serializer.toJson<String>(timeZoneId),
      'enabled': serializer.toJson<bool>(enabled),
      'platformTaskId': serializer.toJson<String?>(platformTaskId),
      'nextRunAtUtc': serializer.toJson<DateTime>(nextRunAtUtc),
      'lastAttemptAtUtc': serializer.toJson<DateTime?>(lastAttemptAtUtc),
      'lastSucceededAtUtc': serializer.toJson<DateTime?>(lastSucceededAtUtc),
      'lastOutcome': serializer.toJson<String?>(lastOutcome),
      'failureMessage': serializer.toJson<String?>(failureMessage),
    };
  }

  Schedule copyWith({
    String? localWorkflowId,
    String? localTime,
    String? timeZoneId,
    bool? enabled,
    Value<String?> platformTaskId = const Value.absent(),
    DateTime? nextRunAtUtc,
    Value<DateTime?> lastAttemptAtUtc = const Value.absent(),
    Value<DateTime?> lastSucceededAtUtc = const Value.absent(),
    Value<String?> lastOutcome = const Value.absent(),
    Value<String?> failureMessage = const Value.absent(),
  }) => Schedule(
    localWorkflowId: localWorkflowId ?? this.localWorkflowId,
    localTime: localTime ?? this.localTime,
    timeZoneId: timeZoneId ?? this.timeZoneId,
    enabled: enabled ?? this.enabled,
    platformTaskId: platformTaskId.present
        ? platformTaskId.value
        : this.platformTaskId,
    nextRunAtUtc: nextRunAtUtc ?? this.nextRunAtUtc,
    lastAttemptAtUtc: lastAttemptAtUtc.present
        ? lastAttemptAtUtc.value
        : this.lastAttemptAtUtc,
    lastSucceededAtUtc: lastSucceededAtUtc.present
        ? lastSucceededAtUtc.value
        : this.lastSucceededAtUtc,
    lastOutcome: lastOutcome.present ? lastOutcome.value : this.lastOutcome,
    failureMessage: failureMessage.present
        ? failureMessage.value
        : this.failureMessage,
  );
  Schedule copyWithCompanion(SchedulesCompanion data) {
    return Schedule(
      localWorkflowId: data.localWorkflowId.present
          ? data.localWorkflowId.value
          : this.localWorkflowId,
      localTime: data.localTime.present ? data.localTime.value : this.localTime,
      timeZoneId: data.timeZoneId.present
          ? data.timeZoneId.value
          : this.timeZoneId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      platformTaskId: data.platformTaskId.present
          ? data.platformTaskId.value
          : this.platformTaskId,
      nextRunAtUtc: data.nextRunAtUtc.present
          ? data.nextRunAtUtc.value
          : this.nextRunAtUtc,
      lastAttemptAtUtc: data.lastAttemptAtUtc.present
          ? data.lastAttemptAtUtc.value
          : this.lastAttemptAtUtc,
      lastSucceededAtUtc: data.lastSucceededAtUtc.present
          ? data.lastSucceededAtUtc.value
          : this.lastSucceededAtUtc,
      lastOutcome: data.lastOutcome.present
          ? data.lastOutcome.value
          : this.lastOutcome,
      failureMessage: data.failureMessage.present
          ? data.failureMessage.value
          : this.failureMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Schedule(')
          ..write('localWorkflowId: $localWorkflowId, ')
          ..write('localTime: $localTime, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('enabled: $enabled, ')
          ..write('platformTaskId: $platformTaskId, ')
          ..write('nextRunAtUtc: $nextRunAtUtc, ')
          ..write('lastAttemptAtUtc: $lastAttemptAtUtc, ')
          ..write('lastSucceededAtUtc: $lastSucceededAtUtc, ')
          ..write('lastOutcome: $lastOutcome, ')
          ..write('failureMessage: $failureMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localWorkflowId,
    localTime,
    timeZoneId,
    enabled,
    platformTaskId,
    nextRunAtUtc,
    lastAttemptAtUtc,
    lastSucceededAtUtc,
    lastOutcome,
    failureMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Schedule &&
          other.localWorkflowId == this.localWorkflowId &&
          other.localTime == this.localTime &&
          other.timeZoneId == this.timeZoneId &&
          other.enabled == this.enabled &&
          other.platformTaskId == this.platformTaskId &&
          other.nextRunAtUtc == this.nextRunAtUtc &&
          other.lastAttemptAtUtc == this.lastAttemptAtUtc &&
          other.lastSucceededAtUtc == this.lastSucceededAtUtc &&
          other.lastOutcome == this.lastOutcome &&
          other.failureMessage == this.failureMessage);
}

class SchedulesCompanion extends UpdateCompanion<Schedule> {
  final Value<String> localWorkflowId;
  final Value<String> localTime;
  final Value<String> timeZoneId;
  final Value<bool> enabled;
  final Value<String?> platformTaskId;
  final Value<DateTime> nextRunAtUtc;
  final Value<DateTime?> lastAttemptAtUtc;
  final Value<DateTime?> lastSucceededAtUtc;
  final Value<String?> lastOutcome;
  final Value<String?> failureMessage;
  final Value<int> rowid;
  const SchedulesCompanion({
    this.localWorkflowId = const Value.absent(),
    this.localTime = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.platformTaskId = const Value.absent(),
    this.nextRunAtUtc = const Value.absent(),
    this.lastAttemptAtUtc = const Value.absent(),
    this.lastSucceededAtUtc = const Value.absent(),
    this.lastOutcome = const Value.absent(),
    this.failureMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulesCompanion.insert({
    required String localWorkflowId,
    required String localTime,
    required String timeZoneId,
    this.enabled = const Value.absent(),
    this.platformTaskId = const Value.absent(),
    required DateTime nextRunAtUtc,
    this.lastAttemptAtUtc = const Value.absent(),
    this.lastSucceededAtUtc = const Value.absent(),
    this.lastOutcome = const Value.absent(),
    this.failureMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localWorkflowId = Value(localWorkflowId),
       localTime = Value(localTime),
       timeZoneId = Value(timeZoneId),
       nextRunAtUtc = Value(nextRunAtUtc);
  static Insertable<Schedule> custom({
    Expression<String>? localWorkflowId,
    Expression<String>? localTime,
    Expression<String>? timeZoneId,
    Expression<bool>? enabled,
    Expression<String>? platformTaskId,
    Expression<DateTime>? nextRunAtUtc,
    Expression<DateTime>? lastAttemptAtUtc,
    Expression<DateTime>? lastSucceededAtUtc,
    Expression<String>? lastOutcome,
    Expression<String>? failureMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localWorkflowId != null) 'local_workflow_id': localWorkflowId,
      if (localTime != null) 'local_time': localTime,
      if (timeZoneId != null) 'time_zone_id': timeZoneId,
      if (enabled != null) 'enabled': enabled,
      if (platformTaskId != null) 'platform_task_id': platformTaskId,
      if (nextRunAtUtc != null) 'next_run_at_utc': nextRunAtUtc,
      if (lastAttemptAtUtc != null) 'last_attempt_at_utc': lastAttemptAtUtc,
      if (lastSucceededAtUtc != null)
        'last_succeeded_at_utc': lastSucceededAtUtc,
      if (lastOutcome != null) 'last_outcome': lastOutcome,
      if (failureMessage != null) 'failure_message': failureMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulesCompanion copyWith({
    Value<String>? localWorkflowId,
    Value<String>? localTime,
    Value<String>? timeZoneId,
    Value<bool>? enabled,
    Value<String?>? platformTaskId,
    Value<DateTime>? nextRunAtUtc,
    Value<DateTime?>? lastAttemptAtUtc,
    Value<DateTime?>? lastSucceededAtUtc,
    Value<String?>? lastOutcome,
    Value<String?>? failureMessage,
    Value<int>? rowid,
  }) {
    return SchedulesCompanion(
      localWorkflowId: localWorkflowId ?? this.localWorkflowId,
      localTime: localTime ?? this.localTime,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      enabled: enabled ?? this.enabled,
      platformTaskId: platformTaskId ?? this.platformTaskId,
      nextRunAtUtc: nextRunAtUtc ?? this.nextRunAtUtc,
      lastAttemptAtUtc: lastAttemptAtUtc ?? this.lastAttemptAtUtc,
      lastSucceededAtUtc: lastSucceededAtUtc ?? this.lastSucceededAtUtc,
      lastOutcome: lastOutcome ?? this.lastOutcome,
      failureMessage: failureMessage ?? this.failureMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localWorkflowId.present) {
      map['local_workflow_id'] = Variable<String>(localWorkflowId.value);
    }
    if (localTime.present) {
      map['local_time'] = Variable<String>(localTime.value);
    }
    if (timeZoneId.present) {
      map['time_zone_id'] = Variable<String>(timeZoneId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (platformTaskId.present) {
      map['platform_task_id'] = Variable<String>(platformTaskId.value);
    }
    if (nextRunAtUtc.present) {
      map['next_run_at_utc'] = Variable<DateTime>(nextRunAtUtc.value);
    }
    if (lastAttemptAtUtc.present) {
      map['last_attempt_at_utc'] = Variable<DateTime>(lastAttemptAtUtc.value);
    }
    if (lastSucceededAtUtc.present) {
      map['last_succeeded_at_utc'] = Variable<DateTime>(
        lastSucceededAtUtc.value,
      );
    }
    if (lastOutcome.present) {
      map['last_outcome'] = Variable<String>(lastOutcome.value);
    }
    if (failureMessage.present) {
      map['failure_message'] = Variable<String>(failureMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('localWorkflowId: $localWorkflowId, ')
          ..write('localTime: $localTime, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('enabled: $enabled, ')
          ..write('platformTaskId: $platformTaskId, ')
          ..write('nextRunAtUtc: $nextRunAtUtc, ')
          ..write('lastAttemptAtUtc: $lastAttemptAtUtc, ')
          ..write('lastSucceededAtUtc: $lastSucceededAtUtc, ')
          ..write('lastOutcome: $lastOutcome, ')
          ..write('failureMessage: $failureMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConnectorCredentialsTable extends ConnectorCredentials
    with TableInfo<$ConnectorCredentialsTable, ConnectorCredential> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConnectorCredentialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _connectorKeyMeta = const VerificationMeta(
    'connectorKey',
  );
  @override
  late final GeneratedColumn<String> connectorKey = GeneratedColumn<String>(
    'connector_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldKeyMeta = const VerificationMeta(
    'fieldKey',
  );
  @override
  late final GeneratedColumn<String> fieldKey = GeneratedColumn<String>(
    'field_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    connectorKey,
    fieldKey,
    value,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'connector_credentials';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConnectorCredential> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('connector_key')) {
      context.handle(
        _connectorKeyMeta,
        connectorKey.isAcceptableOrUnknown(
          data['connector_key']!,
          _connectorKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectorKeyMeta);
    }
    if (data.containsKey('field_key')) {
      context.handle(
        _fieldKeyMeta,
        fieldKey.isAcceptableOrUnknown(data['field_key']!, _fieldKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldKeyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {connectorKey, fieldKey};
  @override
  ConnectorCredential map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConnectorCredential(
      connectorKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connector_key'],
      )!,
      fieldKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $ConnectorCredentialsTable createAlias(String alias) {
    return $ConnectorCredentialsTable(attachedDatabase, alias);
  }
}

class ConnectorCredential extends DataClass
    implements Insertable<ConnectorCredential> {
  final String connectorKey;
  final String fieldKey;
  final String value;
  final DateTime updatedAtUtc;
  const ConnectorCredential({
    required this.connectorKey,
    required this.fieldKey,
    required this.value,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['connector_key'] = Variable<String>(connectorKey);
    map['field_key'] = Variable<String>(fieldKey);
    map['value'] = Variable<String>(value);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  ConnectorCredentialsCompanion toCompanion(bool nullToAbsent) {
    return ConnectorCredentialsCompanion(
      connectorKey: Value(connectorKey),
      fieldKey: Value(fieldKey),
      value: Value(value),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory ConnectorCredential.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConnectorCredential(
      connectorKey: serializer.fromJson<String>(json['connectorKey']),
      fieldKey: serializer.fromJson<String>(json['fieldKey']),
      value: serializer.fromJson<String>(json['value']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'connectorKey': serializer.toJson<String>(connectorKey),
      'fieldKey': serializer.toJson<String>(fieldKey),
      'value': serializer.toJson<String>(value),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  ConnectorCredential copyWith({
    String? connectorKey,
    String? fieldKey,
    String? value,
    DateTime? updatedAtUtc,
  }) => ConnectorCredential(
    connectorKey: connectorKey ?? this.connectorKey,
    fieldKey: fieldKey ?? this.fieldKey,
    value: value ?? this.value,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  ConnectorCredential copyWithCompanion(ConnectorCredentialsCompanion data) {
    return ConnectorCredential(
      connectorKey: data.connectorKey.present
          ? data.connectorKey.value
          : this.connectorKey,
      fieldKey: data.fieldKey.present ? data.fieldKey.value : this.fieldKey,
      value: data.value.present ? data.value.value : this.value,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConnectorCredential(')
          ..write('connectorKey: $connectorKey, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('value: $value, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(connectorKey, fieldKey, value, updatedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConnectorCredential &&
          other.connectorKey == this.connectorKey &&
          other.fieldKey == this.fieldKey &&
          other.value == this.value &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class ConnectorCredentialsCompanion
    extends UpdateCompanion<ConnectorCredential> {
  final Value<String> connectorKey;
  final Value<String> fieldKey;
  final Value<String> value;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const ConnectorCredentialsCompanion({
    this.connectorKey = const Value.absent(),
    this.fieldKey = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConnectorCredentialsCompanion.insert({
    required String connectorKey,
    required String fieldKey,
    required String value,
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : connectorKey = Value(connectorKey),
       fieldKey = Value(fieldKey),
       value = Value(value),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<ConnectorCredential> custom({
    Expression<String>? connectorKey,
    Expression<String>? fieldKey,
    Expression<String>? value,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (connectorKey != null) 'connector_key': connectorKey,
      if (fieldKey != null) 'field_key': fieldKey,
      if (value != null) 'value': value,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConnectorCredentialsCompanion copyWith({
    Value<String>? connectorKey,
    Value<String>? fieldKey,
    Value<String>? value,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return ConnectorCredentialsCompanion(
      connectorKey: connectorKey ?? this.connectorKey,
      fieldKey: fieldKey ?? this.fieldKey,
      value: value ?? this.value,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (connectorKey.present) {
      map['connector_key'] = Variable<String>(connectorKey.value);
    }
    if (fieldKey.present) {
      map['field_key'] = Variable<String>(fieldKey.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConnectorCredentialsCompanion(')
          ..write('connectorKey: $connectorKey, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('value: $value, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PresetCacheTable presetCache = $PresetCacheTable(this);
  late final $WorkflowInstancesTable workflowInstances =
      $WorkflowInstancesTable(this);
  late final $WorkflowRunsTable workflowRuns = $WorkflowRunsTable(this);
  late final $WorkflowNodeRunsTable workflowNodeRuns = $WorkflowNodeRunsTable(
    this,
  );
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $ConnectorCredentialsTable connectorCredentials =
      $ConnectorCredentialsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    presetCache,
    workflowInstances,
    workflowRuns,
    workflowNodeRuns,
    schedules,
    connectorCredentials,
  ];
}

typedef $$PresetCacheTableCreateCompanionBuilder =
    PresetCacheCompanion Function({
      required String key,
      required int version,
      required String responseJson,
      required DateTime fetchedAtUtc,
      Value<int> rowid,
    });
typedef $$PresetCacheTableUpdateCompanionBuilder =
    PresetCacheCompanion Function({
      Value<String> key,
      Value<int> version,
      Value<String> responseJson,
      Value<DateTime> fetchedAtUtc,
      Value<int> rowid,
    });

class $$PresetCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PresetCacheTable> {
  $$PresetCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PresetCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PresetCacheTable> {
  $$PresetCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PresetCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresetCacheTable> {
  $$PresetCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => column,
  );
}

class $$PresetCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresetCacheTable,
          PresetCacheData,
          $$PresetCacheTableFilterComposer,
          $$PresetCacheTableOrderingComposer,
          $$PresetCacheTableAnnotationComposer,
          $$PresetCacheTableCreateCompanionBuilder,
          $$PresetCacheTableUpdateCompanionBuilder,
          (
            PresetCacheData,
            BaseReferences<_$AppDatabase, $PresetCacheTable, PresetCacheData>,
          ),
          PresetCacheData,
          PrefetchHooks Function()
        > {
  $$PresetCacheTableTableManager(_$AppDatabase db, $PresetCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresetCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresetCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresetCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> responseJson = const Value.absent(),
                Value<DateTime> fetchedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresetCacheCompanion(
                key: key,
                version: version,
                responseJson: responseJson,
                fetchedAtUtc: fetchedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required int version,
                required String responseJson,
                required DateTime fetchedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => PresetCacheCompanion.insert(
                key: key,
                version: version,
                responseJson: responseJson,
                fetchedAtUtc: fetchedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PresetCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresetCacheTable,
      PresetCacheData,
      $$PresetCacheTableFilterComposer,
      $$PresetCacheTableOrderingComposer,
      $$PresetCacheTableAnnotationComposer,
      $$PresetCacheTableCreateCompanionBuilder,
      $$PresetCacheTableUpdateCompanionBuilder,
      (
        PresetCacheData,
        BaseReferences<_$AppDatabase, $PresetCacheTable, PresetCacheData>,
      ),
      PresetCacheData,
      PrefetchHooks Function()
    >;
typedef $$WorkflowInstancesTableCreateCompanionBuilder =
    WorkflowInstancesCompanion Function({
      required String id,
      required String presetKey,
      required int presetVersion,
      required String name,
      required String topic,
      Value<String?> modelOverridesJson,
      required DateTime createdAtUtc,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$WorkflowInstancesTableUpdateCompanionBuilder =
    WorkflowInstancesCompanion Function({
      Value<String> id,
      Value<String> presetKey,
      Value<int> presetVersion,
      Value<String> name,
      Value<String> topic,
      Value<String?> modelOverridesJson,
      Value<DateTime> createdAtUtc,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

class $$WorkflowInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkflowInstancesTable> {
  $$WorkflowInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get presetKey => $composableBuilder(
    column: $table.presetKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get presetVersion => $composableBuilder(
    column: $table.presetVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelOverridesJson => $composableBuilder(
    column: $table.modelOverridesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkflowInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkflowInstancesTable> {
  $$WorkflowInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get presetKey => $composableBuilder(
    column: $table.presetKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get presetVersion => $composableBuilder(
    column: $table.presetVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelOverridesJson => $composableBuilder(
    column: $table.modelOverridesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkflowInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkflowInstancesTable> {
  $$WorkflowInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get presetKey =>
      $composableBuilder(column: $table.presetKey, builder: (column) => column);

  GeneratedColumn<int> get presetVersion => $composableBuilder(
    column: $table.presetVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get modelOverridesJson => $composableBuilder(
    column: $table.modelOverridesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$WorkflowInstancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkflowInstancesTable,
          WorkflowInstanceRow,
          $$WorkflowInstancesTableFilterComposer,
          $$WorkflowInstancesTableOrderingComposer,
          $$WorkflowInstancesTableAnnotationComposer,
          $$WorkflowInstancesTableCreateCompanionBuilder,
          $$WorkflowInstancesTableUpdateCompanionBuilder,
          (
            WorkflowInstanceRow,
            BaseReferences<
              _$AppDatabase,
              $WorkflowInstancesTable,
              WorkflowInstanceRow
            >,
          ),
          WorkflowInstanceRow,
          PrefetchHooks Function()
        > {
  $$WorkflowInstancesTableTableManager(
    _$AppDatabase db,
    $WorkflowInstancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkflowInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkflowInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkflowInstancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> presetKey = const Value.absent(),
                Value<int> presetVersion = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String?> modelOverridesJson = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkflowInstancesCompanion(
                id: id,
                presetKey: presetKey,
                presetVersion: presetVersion,
                name: name,
                topic: topic,
                modelOverridesJson: modelOverridesJson,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String presetKey,
                required int presetVersion,
                required String name,
                required String topic,
                Value<String?> modelOverridesJson = const Value.absent(),
                required DateTime createdAtUtc,
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => WorkflowInstancesCompanion.insert(
                id: id,
                presetKey: presetKey,
                presetVersion: presetVersion,
                name: name,
                topic: topic,
                modelOverridesJson: modelOverridesJson,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkflowInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkflowInstancesTable,
      WorkflowInstanceRow,
      $$WorkflowInstancesTableFilterComposer,
      $$WorkflowInstancesTableOrderingComposer,
      $$WorkflowInstancesTableAnnotationComposer,
      $$WorkflowInstancesTableCreateCompanionBuilder,
      $$WorkflowInstancesTableUpdateCompanionBuilder,
      (
        WorkflowInstanceRow,
        BaseReferences<
          _$AppDatabase,
          $WorkflowInstancesTable,
          WorkflowInstanceRow
        >,
      ),
      WorkflowInstanceRow,
      PrefetchHooks Function()
    >;
typedef $$WorkflowRunsTableCreateCompanionBuilder =
    WorkflowRunsCompanion Function({
      required String runId,
      required String localWorkflowId,
      required String presetKey,
      required String status,
      Value<String?> approvalSnapshotJson,
      Value<String?> finalResponse,
      required DateTime createdAtUtc,
      required DateTime updatedAtUtc,
      Value<DateTime?> expiryUtc,
      Value<int> rowid,
    });
typedef $$WorkflowRunsTableUpdateCompanionBuilder =
    WorkflowRunsCompanion Function({
      Value<String> runId,
      Value<String> localWorkflowId,
      Value<String> presetKey,
      Value<String> status,
      Value<String?> approvalSnapshotJson,
      Value<String?> finalResponse,
      Value<DateTime> createdAtUtc,
      Value<DateTime> updatedAtUtc,
      Value<DateTime?> expiryUtc,
      Value<int> rowid,
    });

class $$WorkflowRunsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkflowRunsTable> {
  $$WorkflowRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localWorkflowId => $composableBuilder(
    column: $table.localWorkflowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get presetKey => $composableBuilder(
    column: $table.presetKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvalSnapshotJson => $composableBuilder(
    column: $table.approvalSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalResponse => $composableBuilder(
    column: $table.finalResponse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryUtc => $composableBuilder(
    column: $table.expiryUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkflowRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkflowRunsTable> {
  $$WorkflowRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localWorkflowId => $composableBuilder(
    column: $table.localWorkflowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get presetKey => $composableBuilder(
    column: $table.presetKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvalSnapshotJson => $composableBuilder(
    column: $table.approvalSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalResponse => $composableBuilder(
    column: $table.finalResponse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryUtc => $composableBuilder(
    column: $table.expiryUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkflowRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkflowRunsTable> {
  $$WorkflowRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get runId =>
      $composableBuilder(column: $table.runId, builder: (column) => column);

  GeneratedColumn<String> get localWorkflowId => $composableBuilder(
    column: $table.localWorkflowId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get presetKey =>
      $composableBuilder(column: $table.presetKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get approvalSnapshotJson => $composableBuilder(
    column: $table.approvalSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get finalResponse => $composableBuilder(
    column: $table.finalResponse,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryUtc =>
      $composableBuilder(column: $table.expiryUtc, builder: (column) => column);
}

class $$WorkflowRunsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkflowRunsTable,
          WorkflowRunRow,
          $$WorkflowRunsTableFilterComposer,
          $$WorkflowRunsTableOrderingComposer,
          $$WorkflowRunsTableAnnotationComposer,
          $$WorkflowRunsTableCreateCompanionBuilder,
          $$WorkflowRunsTableUpdateCompanionBuilder,
          (
            WorkflowRunRow,
            BaseReferences<_$AppDatabase, $WorkflowRunsTable, WorkflowRunRow>,
          ),
          WorkflowRunRow,
          PrefetchHooks Function()
        > {
  $$WorkflowRunsTableTableManager(_$AppDatabase db, $WorkflowRunsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkflowRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkflowRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkflowRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> runId = const Value.absent(),
                Value<String> localWorkflowId = const Value.absent(),
                Value<String> presetKey = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> approvalSnapshotJson = const Value.absent(),
                Value<String?> finalResponse = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<DateTime?> expiryUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkflowRunsCompanion(
                runId: runId,
                localWorkflowId: localWorkflowId,
                presetKey: presetKey,
                status: status,
                approvalSnapshotJson: approvalSnapshotJson,
                finalResponse: finalResponse,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                expiryUtc: expiryUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String runId,
                required String localWorkflowId,
                required String presetKey,
                required String status,
                Value<String?> approvalSnapshotJson = const Value.absent(),
                Value<String?> finalResponse = const Value.absent(),
                required DateTime createdAtUtc,
                required DateTime updatedAtUtc,
                Value<DateTime?> expiryUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkflowRunsCompanion.insert(
                runId: runId,
                localWorkflowId: localWorkflowId,
                presetKey: presetKey,
                status: status,
                approvalSnapshotJson: approvalSnapshotJson,
                finalResponse: finalResponse,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                expiryUtc: expiryUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkflowRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkflowRunsTable,
      WorkflowRunRow,
      $$WorkflowRunsTableFilterComposer,
      $$WorkflowRunsTableOrderingComposer,
      $$WorkflowRunsTableAnnotationComposer,
      $$WorkflowRunsTableCreateCompanionBuilder,
      $$WorkflowRunsTableUpdateCompanionBuilder,
      (
        WorkflowRunRow,
        BaseReferences<_$AppDatabase, $WorkflowRunsTable, WorkflowRunRow>,
      ),
      WorkflowRunRow,
      PrefetchHooks Function()
    >;
typedef $$WorkflowNodeRunsTableCreateCompanionBuilder =
    WorkflowNodeRunsCompanion Function({
      required String runId,
      required String nodeId,
      required String nodeKey,
      required String displayName,
      required String type,
      required String status,
      Value<String?> output,
      Value<String?> error,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$WorkflowNodeRunsTableUpdateCompanionBuilder =
    WorkflowNodeRunsCompanion Function({
      Value<String> runId,
      Value<String> nodeId,
      Value<String> nodeKey,
      Value<String> displayName,
      Value<String> type,
      Value<String> status,
      Value<String?> output,
      Value<String?> error,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

class $$WorkflowNodeRunsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkflowNodeRunsTable> {
  $$WorkflowNodeRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeKey => $composableBuilder(
    column: $table.nodeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get output => $composableBuilder(
    column: $table.output,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkflowNodeRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkflowNodeRunsTable> {
  $$WorkflowNodeRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get runId => $composableBuilder(
    column: $table.runId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeKey => $composableBuilder(
    column: $table.nodeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get output => $composableBuilder(
    column: $table.output,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkflowNodeRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkflowNodeRunsTable> {
  $$WorkflowNodeRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get runId =>
      $composableBuilder(column: $table.runId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get nodeKey =>
      $composableBuilder(column: $table.nodeKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get output =>
      $composableBuilder(column: $table.output, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$WorkflowNodeRunsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkflowNodeRunsTable,
          WorkflowNodeRunRow,
          $$WorkflowNodeRunsTableFilterComposer,
          $$WorkflowNodeRunsTableOrderingComposer,
          $$WorkflowNodeRunsTableAnnotationComposer,
          $$WorkflowNodeRunsTableCreateCompanionBuilder,
          $$WorkflowNodeRunsTableUpdateCompanionBuilder,
          (
            WorkflowNodeRunRow,
            BaseReferences<
              _$AppDatabase,
              $WorkflowNodeRunsTable,
              WorkflowNodeRunRow
            >,
          ),
          WorkflowNodeRunRow,
          PrefetchHooks Function()
        > {
  $$WorkflowNodeRunsTableTableManager(
    _$AppDatabase db,
    $WorkflowNodeRunsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkflowNodeRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkflowNodeRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkflowNodeRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> runId = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> nodeKey = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> output = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkflowNodeRunsCompanion(
                runId: runId,
                nodeId: nodeId,
                nodeKey: nodeKey,
                displayName: displayName,
                type: type,
                status: status,
                output: output,
                error: error,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String runId,
                required String nodeId,
                required String nodeKey,
                required String displayName,
                required String type,
                required String status,
                Value<String?> output = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => WorkflowNodeRunsCompanion.insert(
                runId: runId,
                nodeId: nodeId,
                nodeKey: nodeKey,
                displayName: displayName,
                type: type,
                status: status,
                output: output,
                error: error,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkflowNodeRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkflowNodeRunsTable,
      WorkflowNodeRunRow,
      $$WorkflowNodeRunsTableFilterComposer,
      $$WorkflowNodeRunsTableOrderingComposer,
      $$WorkflowNodeRunsTableAnnotationComposer,
      $$WorkflowNodeRunsTableCreateCompanionBuilder,
      $$WorkflowNodeRunsTableUpdateCompanionBuilder,
      (
        WorkflowNodeRunRow,
        BaseReferences<
          _$AppDatabase,
          $WorkflowNodeRunsTable,
          WorkflowNodeRunRow
        >,
      ),
      WorkflowNodeRunRow,
      PrefetchHooks Function()
    >;
typedef $$SchedulesTableCreateCompanionBuilder =
    SchedulesCompanion Function({
      required String localWorkflowId,
      required String localTime,
      required String timeZoneId,
      Value<bool> enabled,
      Value<String?> platformTaskId,
      required DateTime nextRunAtUtc,
      Value<DateTime?> lastAttemptAtUtc,
      Value<DateTime?> lastSucceededAtUtc,
      Value<String?> lastOutcome,
      Value<String?> failureMessage,
      Value<int> rowid,
    });
typedef $$SchedulesTableUpdateCompanionBuilder =
    SchedulesCompanion Function({
      Value<String> localWorkflowId,
      Value<String> localTime,
      Value<String> timeZoneId,
      Value<bool> enabled,
      Value<String?> platformTaskId,
      Value<DateTime> nextRunAtUtc,
      Value<DateTime?> lastAttemptAtUtc,
      Value<DateTime?> lastSucceededAtUtc,
      Value<String?> lastOutcome,
      Value<String?> failureMessage,
      Value<int> rowid,
    });

class $$SchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localWorkflowId => $composableBuilder(
    column: $table.localWorkflowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZoneId => $composableBuilder(
    column: $table.timeZoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformTaskId => $composableBuilder(
    column: $table.platformTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRunAtUtc => $composableBuilder(
    column: $table.nextRunAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAtUtc => $composableBuilder(
    column: $table.lastAttemptAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSucceededAtUtc => $composableBuilder(
    column: $table.lastSucceededAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastOutcome => $composableBuilder(
    column: $table.lastOutcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failureMessage => $composableBuilder(
    column: $table.failureMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localWorkflowId => $composableBuilder(
    column: $table.localWorkflowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZoneId => $composableBuilder(
    column: $table.timeZoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformTaskId => $composableBuilder(
    column: $table.platformTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRunAtUtc => $composableBuilder(
    column: $table.nextRunAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAtUtc => $composableBuilder(
    column: $table.lastAttemptAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSucceededAtUtc => $composableBuilder(
    column: $table.lastSucceededAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastOutcome => $composableBuilder(
    column: $table.lastOutcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failureMessage => $composableBuilder(
    column: $table.failureMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localWorkflowId => $composableBuilder(
    column: $table.localWorkflowId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localTime =>
      $composableBuilder(column: $table.localTime, builder: (column) => column);

  GeneratedColumn<String> get timeZoneId => $composableBuilder(
    column: $table.timeZoneId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get platformTaskId => $composableBuilder(
    column: $table.platformTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRunAtUtc => $composableBuilder(
    column: $table.nextRunAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAttemptAtUtc => $composableBuilder(
    column: $table.lastAttemptAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSucceededAtUtc => $composableBuilder(
    column: $table.lastSucceededAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastOutcome => $composableBuilder(
    column: $table.lastOutcome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get failureMessage => $composableBuilder(
    column: $table.failureMessage,
    builder: (column) => column,
  );
}

class $$SchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchedulesTable,
          Schedule,
          $$SchedulesTableFilterComposer,
          $$SchedulesTableOrderingComposer,
          $$SchedulesTableAnnotationComposer,
          $$SchedulesTableCreateCompanionBuilder,
          $$SchedulesTableUpdateCompanionBuilder,
          (Schedule, BaseReferences<_$AppDatabase, $SchedulesTable, Schedule>),
          Schedule,
          PrefetchHooks Function()
        > {
  $$SchedulesTableTableManager(_$AppDatabase db, $SchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localWorkflowId = const Value.absent(),
                Value<String> localTime = const Value.absent(),
                Value<String> timeZoneId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String?> platformTaskId = const Value.absent(),
                Value<DateTime> nextRunAtUtc = const Value.absent(),
                Value<DateTime?> lastAttemptAtUtc = const Value.absent(),
                Value<DateTime?> lastSucceededAtUtc = const Value.absent(),
                Value<String?> lastOutcome = const Value.absent(),
                Value<String?> failureMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion(
                localWorkflowId: localWorkflowId,
                localTime: localTime,
                timeZoneId: timeZoneId,
                enabled: enabled,
                platformTaskId: platformTaskId,
                nextRunAtUtc: nextRunAtUtc,
                lastAttemptAtUtc: lastAttemptAtUtc,
                lastSucceededAtUtc: lastSucceededAtUtc,
                lastOutcome: lastOutcome,
                failureMessage: failureMessage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localWorkflowId,
                required String localTime,
                required String timeZoneId,
                Value<bool> enabled = const Value.absent(),
                Value<String?> platformTaskId = const Value.absent(),
                required DateTime nextRunAtUtc,
                Value<DateTime?> lastAttemptAtUtc = const Value.absent(),
                Value<DateTime?> lastSucceededAtUtc = const Value.absent(),
                Value<String?> lastOutcome = const Value.absent(),
                Value<String?> failureMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion.insert(
                localWorkflowId: localWorkflowId,
                localTime: localTime,
                timeZoneId: timeZoneId,
                enabled: enabled,
                platformTaskId: platformTaskId,
                nextRunAtUtc: nextRunAtUtc,
                lastAttemptAtUtc: lastAttemptAtUtc,
                lastSucceededAtUtc: lastSucceededAtUtc,
                lastOutcome: lastOutcome,
                failureMessage: failureMessage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchedulesTable,
      Schedule,
      $$SchedulesTableFilterComposer,
      $$SchedulesTableOrderingComposer,
      $$SchedulesTableAnnotationComposer,
      $$SchedulesTableCreateCompanionBuilder,
      $$SchedulesTableUpdateCompanionBuilder,
      (Schedule, BaseReferences<_$AppDatabase, $SchedulesTable, Schedule>),
      Schedule,
      PrefetchHooks Function()
    >;
typedef $$ConnectorCredentialsTableCreateCompanionBuilder =
    ConnectorCredentialsCompanion Function({
      required String connectorKey,
      required String fieldKey,
      required String value,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$ConnectorCredentialsTableUpdateCompanionBuilder =
    ConnectorCredentialsCompanion Function({
      Value<String> connectorKey,
      Value<String> fieldKey,
      Value<String> value,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

class $$ConnectorCredentialsTableFilterComposer
    extends Composer<_$AppDatabase, $ConnectorCredentialsTable> {
  $$ConnectorCredentialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get connectorKey => $composableBuilder(
    column: $table.connectorKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldKey => $composableBuilder(
    column: $table.fieldKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConnectorCredentialsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConnectorCredentialsTable> {
  $$ConnectorCredentialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get connectorKey => $composableBuilder(
    column: $table.connectorKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldKey => $composableBuilder(
    column: $table.fieldKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConnectorCredentialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConnectorCredentialsTable> {
  $$ConnectorCredentialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get connectorKey => $composableBuilder(
    column: $table.connectorKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldKey =>
      $composableBuilder(column: $table.fieldKey, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$ConnectorCredentialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConnectorCredentialsTable,
          ConnectorCredential,
          $$ConnectorCredentialsTableFilterComposer,
          $$ConnectorCredentialsTableOrderingComposer,
          $$ConnectorCredentialsTableAnnotationComposer,
          $$ConnectorCredentialsTableCreateCompanionBuilder,
          $$ConnectorCredentialsTableUpdateCompanionBuilder,
          (
            ConnectorCredential,
            BaseReferences<
              _$AppDatabase,
              $ConnectorCredentialsTable,
              ConnectorCredential
            >,
          ),
          ConnectorCredential,
          PrefetchHooks Function()
        > {
  $$ConnectorCredentialsTableTableManager(
    _$AppDatabase db,
    $ConnectorCredentialsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConnectorCredentialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConnectorCredentialsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConnectorCredentialsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> connectorKey = const Value.absent(),
                Value<String> fieldKey = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConnectorCredentialsCompanion(
                connectorKey: connectorKey,
                fieldKey: fieldKey,
                value: value,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String connectorKey,
                required String fieldKey,
                required String value,
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => ConnectorCredentialsCompanion.insert(
                connectorKey: connectorKey,
                fieldKey: fieldKey,
                value: value,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConnectorCredentialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConnectorCredentialsTable,
      ConnectorCredential,
      $$ConnectorCredentialsTableFilterComposer,
      $$ConnectorCredentialsTableOrderingComposer,
      $$ConnectorCredentialsTableAnnotationComposer,
      $$ConnectorCredentialsTableCreateCompanionBuilder,
      $$ConnectorCredentialsTableUpdateCompanionBuilder,
      (
        ConnectorCredential,
        BaseReferences<
          _$AppDatabase,
          $ConnectorCredentialsTable,
          ConnectorCredential
        >,
      ),
      ConnectorCredential,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PresetCacheTableTableManager get presetCache =>
      $$PresetCacheTableTableManager(_db, _db.presetCache);
  $$WorkflowInstancesTableTableManager get workflowInstances =>
      $$WorkflowInstancesTableTableManager(_db, _db.workflowInstances);
  $$WorkflowRunsTableTableManager get workflowRuns =>
      $$WorkflowRunsTableTableManager(_db, _db.workflowRuns);
  $$WorkflowNodeRunsTableTableManager get workflowNodeRuns =>
      $$WorkflowNodeRunsTableTableManager(_db, _db.workflowNodeRuns);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db, _db.schedules);
  $$ConnectorCredentialsTableTableManager get connectorCredentials =>
      $$ConnectorCredentialsTableTableManager(_db, _db.connectorCredentials);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'1275c06d656588fdb57e5e7958cf4f272f1878e7';
