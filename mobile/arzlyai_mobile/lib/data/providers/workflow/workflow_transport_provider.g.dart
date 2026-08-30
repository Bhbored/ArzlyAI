// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_transport_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkflowTransport)
final workflowTransportProvider = WorkflowTransportProvider._();

final class WorkflowTransportProvider
    extends $NotifierProvider<WorkflowTransport, WorkflowTransportStatus> {
  WorkflowTransportProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'workflowTransportProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowTransportHash();

  @$internal
  @override
  WorkflowTransport create() => WorkflowTransport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkflowTransportStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkflowTransportStatus>(value),
    );
  }
}

String _$workflowTransportHash() => r'2b4ed00bd0c5101399234061ede5480c9740e673';

abstract class _$WorkflowTransport extends $Notifier<WorkflowTransportStatus> {
  WorkflowTransportStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<WorkflowTransportStatus, WorkflowTransportStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkflowTransportStatus, WorkflowTransportStatus>,
              WorkflowTransportStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
