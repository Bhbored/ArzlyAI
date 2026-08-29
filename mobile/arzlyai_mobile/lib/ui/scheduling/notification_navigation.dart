import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/core/notifications/notification_payload.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/scheduling/schedule_providers.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_preset_key_provider.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/repositories/workflow_repository.dart';
import 'package:arzlyai_mobile/ui/features/presets/details/preset_details_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/daily_linkedin_ai_post/review_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppSchedulingShell extends ConsumerStatefulWidget {
  const AppSchedulingShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppSchedulingShell> createState() => _AppSchedulingShellState();
}

class _AppSchedulingShellState extends ConsumerState<AppSchedulingShell>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(initializeWorkflowSchedulingProvider.future);
      final notifications = await ref.read(localNotificationServiceProvider.future);
      notifications.setTapHandler((_) => _handlePendingNotification());
      await _handlePendingNotification();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(workflowSchedulerProvider.future).then(
        (scheduler) => scheduler.reconcileEnabledSchedules(),
      );
      _handlePendingNotification();
    }
  }

  Future<void> _handlePendingNotification() async {
    final notifications = await ref.read(localNotificationServiceProvider.future);
    final payload = notifications.consumePendingTap();
    if (payload == null) return;
    await _navigateForPayload(payload);
  }

  Future<void> _navigateForPayload(NotificationPayload payload) async {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) return;

    if (payload.localWorkflowId != null) {
      final instance = await ref
          .read(workflowRepositoryProvider)
          .getInstance(payload.localWorkflowId!);
      if (instance != null) {
        ref.read(selectedPresetKeyProvider.notifier).update(instance.presetKey);
        await ref.read(presetDetailsProvider.future);
      }
    }

    if (payload.runId != null) {
      ref.read(selectedRunIdProvider.notifier).update(payload.runId!);
    }

    unawaited(
      navigator.push(
        MaterialPageRoute(builder: (_) => const PresetDetailsScreen()),
      ),
    );

    if (payload.action == NotificationActions.review && payload.runId != null) {
      unawaited(
        navigator.push(MaterialPageRoute(builder: (_) => const ReviewScreen())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
