// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dioClient)
final dioClientProvider = DioClientFamily._();

final class DioClientProvider
    extends $FunctionalProvider<DioClient, DioClient, DioClient>
    with $Provider<DioClient> {
  DioClientProvider._({
    required DioClientFamily super.from,
    required (Map<String, String>?, {String endpoint}) super.argument,
  }) : super(
         retry: retry,
         name: r'dioClientProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @override
  String toString() {
    return r'dioClientProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<DioClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DioClient create(Ref ref) {
    final argument = this.argument as (Map<String, String>?, {String endpoint});
    return dioClient(ref, argument.$1, endpoint: argument.endpoint);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioClient>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DioClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dioClientHash() => r'473a7e8a7b9eca32868146c35c53fce7f985f0c6';

final class DioClientFamily extends $Family
    with
        $FunctionalFamilyOverride<
          DioClient,
          (Map<String, String>?, {String endpoint})
        > {
  DioClientFamily._()
    : super(
        retry: retry,
        name: r'dioClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  DioClientProvider call(
    Map<String, String>? headers, {
    required String endpoint,
  }) =>
      DioClientProvider._(argument: (headers, endpoint: endpoint), from: this);

  @override
  String toString() => r'dioClientProvider';
}
