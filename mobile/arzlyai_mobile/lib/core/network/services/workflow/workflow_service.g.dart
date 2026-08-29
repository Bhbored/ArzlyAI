// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workflowService)
final workflowServiceProvider = WorkflowServiceProvider._();

final class WorkflowServiceProvider
    extends
        $FunctionalProvider<WorkflowService, WorkflowService, WorkflowService>
    with $Provider<WorkflowService> {
  WorkflowServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'workflowServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowServiceHash();

  @$internal
  @override
  $ProviderElement<WorkflowService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkflowService create(Ref ref) {
    return workflowService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkflowService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkflowService>(value),
    );
  }
}

String _$workflowServiceHash() => r'034202fc68c96474bfb928b2b50a571fd37c9c08';
