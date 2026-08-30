// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(providerModelRepository)
final providerModelRepositoryProvider = ProviderModelRepositoryProvider._();

final class ProviderModelRepositoryProvider
    extends
        $FunctionalProvider<
          ProviderModelRepository,
          ProviderModelRepository,
          ProviderModelRepository
        >
    with $Provider<ProviderModelRepository> {
  ProviderModelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'providerModelRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$providerModelRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProviderModelRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProviderModelRepository create(Ref ref) {
    return providerModelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProviderModelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProviderModelRepository>(value),
    );
  }
}

String _$providerModelRepositoryHash() =>
    r'f3e63962809dce161b2cd8d12ccee5ad21ac3b54';
