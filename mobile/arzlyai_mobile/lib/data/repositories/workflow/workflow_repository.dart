import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/workflow/workflow_reconciliation.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

part 'workflow_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
WorkflowRepository workflowRepository(Ref ref) {
  return WorkflowRepository(
    ref.read(appDatabaseProvider),
    ref.read(workflowServiceProvider),
    const WorkflowRunMapper(),
    const ArzlyReportMapper(),
  );
}

class WorkflowRepository {
  WorkflowRepository(this._db, this._service, this._mapper, this._reportMapper);

  final AppDatabase _db;
  final WorkflowService _service;
  final WorkflowRunMapper _mapper;
  final ArzlyReportMapper _reportMapper;
  final _uuid = const Uuid();

  Future<WorkflowInstance> createInstance({
    required String presetKey,
    required int presetVersion,
    required String name,
    required String topic,
    String? modelOverridesJson,
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _db
        .into(_db.workflowInstances)
        .insert(
          WorkflowInstancesCompanion.insert(
            id: id,
            presetKey: presetKey,
            presetVersion: presetVersion,
            name: name,
            topic: topic,
            modelOverridesJson: Value(modelOverridesJson),
            createdAtUtc: now,
            updatedAtUtc: now,
          ),
        );
    return WorkflowInstance(
      id: id,
      presetKey: presetKey,
      presetVersion: presetVersion,
      name: name,
      topic: topic,
      modelOverridesJson: modelOverridesJson,
      createdAtUtc: now,
      updatedAtUtc: now,
    );
  }

  Future<WorkflowInstance?> getInstance(String id) async {
    final row = await (_db.select(
      _db.workflowInstances,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return WorkflowInstance(
      id: row.id,
      presetKey: row.presetKey,
      presetVersion: row.presetVersion,
      name: row.name,
      topic: row.topic,
      modelOverridesJson: row.modelOverridesJson,
      createdAtUtc: row.createdAtUtc,
      updatedAtUtc: row.updatedAtUtc,
    );
  }

  Future<void> updateInstance({
    required String id,
    required String topic,
    String? modelOverridesJson,
  }) async {
    final now = DateTime.now().toUtc();
    await (_db.update(
      _db.workflowInstances,
    )..where((t) => t.id.equals(id))).write(
      WorkflowInstancesCompanion(
        topic: Value(topic),
        modelOverridesJson: Value(modelOverridesJson),
        updatedAtUtc: Value(now),
      ),
    );
  }

  Future<bool> hasPendingApproval(String localWorkflowId) async {
    final rows =
        await (_db.select(_db.workflowRuns)..where(
              (t) =>
                  t.localWorkflowId.equals(localWorkflowId) &
                  t.status.equals(
                    WorkflowRunStatus.waitingForApproval.wireValue,
                  ),
            ))
            .get();
    return rows.isNotEmpty;
  }

  Future<WorkflowRun?> latestRunForWorkflow(String localWorkflowId) async {
    final rows =
        await (_db.select(_db.workflowRuns)
              ..where((t) => t.localWorkflowId.equals(localWorkflowId))
              ..orderBy([(t) => OrderingTerm.desc(t.updatedAtUtc)]))
            .get();
    if (rows.isEmpty) return null;
    return getLocalRun(rows.first.runId);
  }

  Future<WorkflowRunResponse> fetchRemote(String runId) =>
      _service.getRun(runId);

  Future<WorkflowRun?> reconcileByRunId(
    String runId, {
    required String localWorkflowId,
    DateTime? expiryUtc,
    Future<void> Function(Duration delay)? wait,
  }) async {
    final pause = wait ?? Future<void>.delayed;
    WorkflowRun? latest;

    Future<WorkflowRun> fetchAndPersist() async {
      final dto = await fetchRemote(runId);
      return persistDto(
        dto,
        localWorkflowId: localWorkflowId,
        expiryUtc: expiryUtc,
      );
    }

    try {
      latest = await fetchAndPersist();
      if (isReconcileTerminal(latest.status)) return latest;
    } on ApiException catch (e) {
      if (e.statusCode == 404) rethrow;
    } on Object catch (_) {
      // Transient failure; continue to backoff polling.
    }

    for (final seconds in reconcileBackoffSeconds) {
      await pause(Duration(seconds: seconds));
      try {
        latest = await fetchAndPersist();
        if (isReconcileTerminal(latest.status)) return latest;
      } on ApiException catch (e) {
        if (e.statusCode == 404) rethrow;
      } on Object {
        continue;
      }
    }
    try {
      return await fetchAndPersist();
    } on ApiException catch (e) {
      if (e.statusCode == 404) rethrow;
      return latest;
    } on Object {
      return latest;
    }
  }

  Future<WorkflowRun?> reconcileLatestForWorkflow(
    String localWorkflowId, {
    DateTime? expiryUtc,
    Future<void> Function(Duration delay)? wait,
  }) async {
    final pause = wait ?? Future<void>.delayed;
    WorkflowRun? latest;
    for (final seconds in reconcileBackoffSeconds) {
      await pause(Duration(seconds: seconds));
      latest = await latestRunForWorkflow(localWorkflowId);
      final runId = latest?.runId;
      if (runId == null) continue;
      final reconciled = await reconcileByRunId(
        runId,
        localWorkflowId: localWorkflowId,
        expiryUtc: expiryUtc ?? latest?.expiryUtc,
        wait: (_) async {},
      );
      if (reconciled != null) return reconciled;
    }
    return latest;
  }

  Future<void> persistRun(WorkflowRun run) async {
    await _db.transaction(() async {
      await _upsertRun(run);
    });
  }

  Future<WorkflowRun> persistDto(
    WorkflowRunResponse dto, {
    required String localWorkflowId,
    DateTime? expiryUtc,
  }) async {
    final now = DateTime.now().toUtc();
    final run = _mapper.fromDto(
      dto,
      localWorkflowId: localWorkflowId,
      createdAtUtc: now,
      updatedAtUtc: now,
      expiryUtc: expiryUtc,
    );
    await persistRun(run);
    return run;
  }

  Future<void> markExpired(String runId) async {
    final now = DateTime.now().toUtc();
    await (_db.update(
      _db.workflowRuns,
    )..where((t) => t.runId.equals(runId))).write(
      WorkflowRunsCompanion(
        status: Value(WorkflowRunStatus.expired.wireValue),
        updatedAtUtc: Value(now),
      ),
    );
  }

  Future<WorkflowRun?> getLocalRun(String runId) async {
    final row = await (_db.select(
      _db.workflowRuns,
    )..where((t) => t.runId.equals(runId))).getSingleOrNull();
    if (row == null) return null;
    final nodes = await (_db.select(
      _db.workflowNodeRuns,
    )..where((t) => t.runId.equals(runId))).get();
    return _fromRows(row, nodes);
  }

  Future<List<WorkflowRun>> listLocalRuns() async {
    final rows = await _db.select(_db.workflowRuns).get();
    final result = <WorkflowRun>[];
    for (final row in rows) {
      final nodes = await (_db.select(
        _db.workflowNodeRuns,
      )..where((t) => t.runId.equals(row.runId))).get();
      result.add(_fromRows(row, nodes));
    }
    return result;
  }

  Future<void> _upsertRun(WorkflowRun run) async {
    final now = run.updatedAtUtc ?? DateTime.now().toUtc();
    await _db
        .into(_db.workflowRuns)
        .insertOnConflictUpdate(
          WorkflowRunsCompanion.insert(
            runId: run.runId,
            localWorkflowId: run.localWorkflowId ?? '',
            presetKey: run.presetKey,
            status: run.status.wireValue,
            approvalSnapshotJson: Value(
              run.approval == null
                  ? null
                  : jsonEncode({
                      'originalContent': run.approval!.originalContent,
                      'currentContent': run.approval!.currentContent,
                      'wasEdited': run.approval!.wasEdited,
                    }),
            ),
            finalResponse: Value(run.finalResponse),
            resultDocumentJson: Value(
              run.report == null ? null : _reportMapper.toJsonString(run.report!),
            ),
            resultContractKey: Value(run.resultContract?.key),
            resultContractVersion: Value(run.resultContract?.version),
            renderedResultMediaType: Value(run.renderedResult?.mediaType),
            renderedResultContent: Value(run.renderedResult?.content),
            createdAtUtc: run.createdAtUtc ?? now,
            updatedAtUtc: now,
            expiryUtc: Value(run.expiryUtc),
          ),
        );
    for (final node in run.nodes) {
      await _db
          .into(_db.workflowNodeRuns)
          .insertOnConflictUpdate(
            WorkflowNodeRunsCompanion.insert(
              runId: run.runId,
              nodeId: node.nodeId,
              nodeKey: node.nodeKey,
              displayName: node.displayName,
              type: node.type,
              status: node.status.wireValue,
              output: Value(node.output),
              error: Value(node.error),
              effectiveProvider: Value(node.effectiveProvider),
              effectiveModel: Value(node.effectiveModel),
              effectiveTemperature: Value(node.effectiveTemperature),
              updatedAtUtc: node.updatedAtUtc ?? now,
            ),
          );
    }
  }

  WorkflowRun _fromRows(WorkflowRunRow row, List<WorkflowNodeRunRow> nodeRows) {
    ApprovalSnapshot? approval;
    if (row.approvalSnapshotJson != null) {
      final json =
          jsonDecode(row.approvalSnapshotJson!) as Map<String, dynamic>;
      approval = ApprovalSnapshot(
        originalContent: json['originalContent'] as String,
        currentContent: json['currentContent'] as String,
        wasEdited: json['wasEdited'] as bool,
      );
    }
    return WorkflowRun(
      runId: row.runId,
      presetKey: row.presetKey,
      status: WorkflowRunStatusX.parse(row.status),
      nodes: nodeRows
          .map(
            (n) => WorkflowNodeRun(
              nodeId: n.nodeId,
              nodeKey: n.nodeKey,
              displayName: n.displayName,
              type: n.type,
              status: WorkflowNodeStatusX.parse(n.status),
              isRunning: n.status == WorkflowNodeStatus.running.wireValue,
              output: n.output,
              error: n.error,
              effectiveProvider: n.effectiveProvider,
              effectiveModel: n.effectiveModel,
              effectiveTemperature: n.effectiveTemperature,
              updatedAtUtc: n.updatedAtUtc,
            ),
          )
          .toList(),
      approval: approval,
      finalResponse: row.finalResponse,
      report: _report(row),
      renderedResult: _renderedResult(row),
      resultContract: _resultContract(row),
      localWorkflowId: row.localWorkflowId,
      createdAtUtc: row.createdAtUtc,
      updatedAtUtc: row.updatedAtUtc,
      expiryUtc: row.expiryUtc,
    );
  }

  ArzlyReport? _report(WorkflowRunRow row) {
    if (row.resultDocumentJson != null) {
      return _reportMapper.fromJsonString(row.resultDocumentJson);
    }
    return _reportMapper.fromJsonString(row.finalResponse);
  }

  RenderedWorkflowResult? _renderedResult(WorkflowRunRow row) {
    final mediaType = row.renderedResultMediaType;
    final content = row.renderedResultContent;
    if (mediaType == null || content == null || content.isEmpty) return null;
    return RenderedWorkflowResult(mediaType: mediaType, content: content);
  }

  ResultContract? _resultContract(WorkflowRunRow row) {
    if (row.resultContractKey != null && row.resultContractVersion != null) {
      return ResultContract(
        key: row.resultContractKey!,
        version: row.resultContractVersion!,
      );
    }
    final report = _report(row);
    if (report == null) return null;
    return ResultContract(key: report.schema, version: report.version);
  }
}
