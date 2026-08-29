import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:arzlyai_mobile/core/crypto/credential_envelope_builder.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/services/preset/preset_service.dart';
import 'package:arzlyai_mobile/core/network/services/security/security_service.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/core/notifications/local_notification_service.dart';
import 'package:arzlyai_mobile/core/scheduling/schedule_occurrence_calculator.dart';
import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';
import 'package:arzlyai_mobile/data/repositories/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credential_store.dart';
import 'package:arzlyai_mobile/data/repositories/preset_repository.dart';
import 'package:arzlyai_mobile/data/repositories/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow_repository.dart';
import 'package:arzlyai_mobile/data/services/scheduling/scheduled_workflow_executor.dart';
import 'package:arzlyai_mobile/data/services/scheduling/workflow_scheduler.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

class WorkflowSchedulingComposition {
  WorkflowSchedulingComposition({
    required this.executor,
    required this.scheduler,
    required this.notifications,
    required this.scheduleRepository,
    required AppDatabase db,
  }) : _db = db;

  final ScheduledWorkflowExecutor executor;
  final WorkflowScheduler scheduler;
  final LocalNotificationService notifications;
  final ScheduleRepository scheduleRepository;
  final AppDatabase _db;

  Future<void> close() => _db.close();

  static Future<void> initializeTimeZone() async {
    tz_data.initializeTimeZones();
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } on Object {
      tz.setLocalLocation(tz.UTC);
    }
  }

  static Future<WorkflowSchedulingComposition> create() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeTimeZone();

    final db = AppDatabase();
    final notifications = await LocalNotificationService.create();
    final scheduleRepository = ScheduleRepository(
      db,
      const ScheduleOccurrenceCalculator(),
    );
    final scheduler = WorkflowScheduler(
      scheduleRepository: scheduleRepository,
      notifications: notifications,
    );

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.defaultBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        contentType: 'application/json',
      ),
    );
    final apiExecutor = ApiExecutor(dio);
    final workflowService = WorkflowService(apiExecutor);
    final securityService = SecurityService(apiExecutor);
    final envelopeService = CredentialEnvelopeService(
      securityService,
      CredentialEnvelopeBuilder(),
    );
    final credentialRepository = CredentialRepository(
      CredentialStore(SecureStorageAndroid()),
      ConnectorCredentialRepository(db),
    );
    final workflowRepository = WorkflowRepository(
      db,
      workflowService,
      const WorkflowRunMapper(),
    );
    final presetRepository = PresetRepository(
      db,
      PresetService(apiExecutor, dio),
      const PresetMapper(),
    );

    final executor = ScheduledWorkflowExecutor(
      workflowRepository: workflowRepository,
      presetRepository: presetRepository,
      credentialRepository: credentialRepository,
      envelopeService: envelopeService,
      workflowService: workflowService,
      scheduleRepository: scheduleRepository,
      notifications: notifications,
      scheduler: scheduler,
    );

    return WorkflowSchedulingComposition(
      executor: executor,
      scheduler: scheduler,
      notifications: notifications,
      scheduleRepository: scheduleRepository,
      db: db,
    );
  }
}
