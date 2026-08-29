// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_hub_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workflowHubClient)
final workflowHubClientProvider = WorkflowHubClientProvider._();

final class WorkflowHubClientProvider
    extends
        $FunctionalProvider<
          WorkflowHubClient,
          WorkflowHubClient,
          WorkflowHubClient
        >
    with $Provider<WorkflowHubClient> {
  WorkflowHubClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'workflowHubClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowHubClientHash();

  @$internal
  @override
  $ProviderElement<WorkflowHubClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkflowHubClient create(Ref ref) {
    return workflowHubClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkflowHubClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkflowHubClient>(value),
    );
  }
}

String _$workflowHubClientHash() => r'ff31ceefc4c8013268aaff11ce76fcbb2bb263a7';
