// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localNotificationService)
final localNotificationServiceProvider = LocalNotificationServiceProvider._();

final class LocalNotificationServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocalNotificationService>,
          LocalNotificationService,
          FutureOr<LocalNotificationService>
        >
    with
        $FutureModifier<LocalNotificationService>,
        $FutureProvider<LocalNotificationService> {
  LocalNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: scheduleRetry,
        name: r'localNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localNotificationServiceHash();

  @$internal
  @override
  $FutureProviderElement<LocalNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocalNotificationService> create(Ref ref) {
    return localNotificationService(ref);
  }
}

String _$localNotificationServiceHash() =>
    r'408a206e00dd9ef347f913db8b2f6454d240c713';

@ProviderFor(workflowScheduler)
final workflowSchedulerProvider = WorkflowSchedulerProvider._();

final class WorkflowSchedulerProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkflowScheduler>,
          WorkflowScheduler,
          FutureOr<WorkflowScheduler>
        >
    with
        $FutureModifier<WorkflowScheduler>,
        $FutureProvider<WorkflowScheduler> {
  WorkflowSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: scheduleRetry,
        name: r'workflowSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowSchedulerHash();

  @$internal
  @override
  $FutureProviderElement<WorkflowScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkflowScheduler> create(Ref ref) {
    return workflowScheduler(ref);
  }
}

String _$workflowSchedulerHash() => r'0adc5cdef15b83b237a35ee839a7ec61bda6a708';

@ProviderFor(scheduledWorkflowExecutor)
final scheduledWorkflowExecutorProvider = ScheduledWorkflowExecutorProvider._();

final class ScheduledWorkflowExecutorProvider
    extends
        $FunctionalProvider<
          AsyncValue<ScheduledWorkflowExecutor>,
          ScheduledWorkflowExecutor,
          FutureOr<ScheduledWorkflowExecutor>
        >
    with
        $FutureModifier<ScheduledWorkflowExecutor>,
        $FutureProvider<ScheduledWorkflowExecutor> {
  ScheduledWorkflowExecutorProvider._()
    : super(
        from: null,
        argument: null,
        retry: scheduleRetry,
        name: r'scheduledWorkflowExecutorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduledWorkflowExecutorHash();

  @$internal
  @override
  $FutureProviderElement<ScheduledWorkflowExecutor> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ScheduledWorkflowExecutor> create(Ref ref) {
    return scheduledWorkflowExecutor(ref);
  }
}

String _$scheduledWorkflowExecutorHash() =>
    r'dfa865bffe6dec9608f4cc41d6b16ce44c7aac3f';

@ProviderFor(workflowScheduleEnabled)
final workflowScheduleEnabledProvider = WorkflowScheduleEnabledFamily._();

final class WorkflowScheduleEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  WorkflowScheduleEnabledProvider._({
    required WorkflowScheduleEnabledFamily super.from,
    required String super.argument,
  }) : super(
         retry: scheduleRetry,
         name: r'workflowScheduleEnabledProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workflowScheduleEnabledHash();

  @override
  String toString() {
    return r'workflowScheduleEnabledProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return workflowScheduleEnabled(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkflowScheduleEnabledProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workflowScheduleEnabledHash() =>
    r'93c1bb0a318740915956d6a760ac624f9eae640b';

final class WorkflowScheduleEnabledFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  WorkflowScheduleEnabledFamily._()
    : super(
        retry: scheduleRetry,
        name: r'workflowScheduleEnabledProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkflowScheduleEnabledProvider call(String localWorkflowId) =>
      WorkflowScheduleEnabledProvider._(argument: localWorkflowId, from: this);

  @override
  String toString() => r'workflowScheduleEnabledProvider';
}

@ProviderFor(scheduledWorkflowIdForPreset)
final scheduledWorkflowIdForPresetProvider =
    ScheduledWorkflowIdForPresetFamily._();

final class ScheduledWorkflowIdForPresetProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  ScheduledWorkflowIdForPresetProvider._({
    required ScheduledWorkflowIdForPresetFamily super.from,
    required String super.argument,
  }) : super(
         retry: scheduleRetry,
         name: r'scheduledWorkflowIdForPresetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scheduledWorkflowIdForPresetHash();

  @override
  String toString() {
    return r'scheduledWorkflowIdForPresetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return scheduledWorkflowIdForPreset(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduledWorkflowIdForPresetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scheduledWorkflowIdForPresetHash() =>
    r'5c0591d4c7c18702684aeea07237d5ba60e532c7';

final class ScheduledWorkflowIdForPresetFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  ScheduledWorkflowIdForPresetFamily._()
    : super(
        retry: scheduleRetry,
        name: r'scheduledWorkflowIdForPresetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ScheduledWorkflowIdForPresetProvider call(String presetKey) =>
      ScheduledWorkflowIdForPresetProvider._(argument: presetKey, from: this);

  @override
  String toString() => r'scheduledWorkflowIdForPresetProvider';
}

@ProviderFor(initializeWorkflowScheduling)
final initializeWorkflowSchedulingProvider =
    InitializeWorkflowSchedulingProvider._();

final class InitializeWorkflowSchedulingProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  InitializeWorkflowSchedulingProvider._()
    : super(
        from: null,
        argument: null,
        retry: scheduleRetry,
        name: r'initializeWorkflowSchedulingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initializeWorkflowSchedulingHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initializeWorkflowScheduling(ref);
  }
}

String _$initializeWorkflowSchedulingHash() =>
    r'a79c8578133725b9e16854d27bff228002401958';

@ProviderFor(ScheduleController)
final scheduleControllerProvider = ScheduleControllerFamily._();

final class ScheduleControllerProvider
    extends $AsyncNotifierProvider<ScheduleController, void> {
  ScheduleControllerProvider._({
    required ScheduleControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: scheduleRetry,
         name: r'scheduleControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scheduleControllerHash();

  @override
  String toString() {
    return r'scheduleControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ScheduleController create() => ScheduleController();

  @override
  bool operator ==(Object other) {
    return other is ScheduleControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scheduleControllerHash() =>
    r'2e107588d7e2f1b6589d7b07964ea649b9139e06';

final class ScheduleControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ScheduleController,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  ScheduleControllerFamily._()
    : super(
        retry: scheduleRetry,
        name: r'scheduleControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ScheduleControllerProvider call(String localWorkflowId) =>
      ScheduleControllerProvider._(argument: localWorkflowId, from: this);

  @override
  String toString() => r'scheduleControllerProvider';
}

abstract class _$ScheduleController extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String;
  String get localWorkflowId => _$args;

  FutureOr<void> build(String localWorkflowId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
