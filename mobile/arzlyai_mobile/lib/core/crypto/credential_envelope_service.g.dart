// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_envelope_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(credentialEnvelopeService)
final credentialEnvelopeServiceProvider = CredentialEnvelopeServiceProvider._();

final class CredentialEnvelopeServiceProvider
    extends
        $FunctionalProvider<
          CredentialEnvelopeService,
          CredentialEnvelopeService,
          CredentialEnvelopeService
        >
    with $Provider<CredentialEnvelopeService> {
  CredentialEnvelopeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'credentialEnvelopeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$credentialEnvelopeServiceHash();

  @$internal
  @override
  $ProviderElement<CredentialEnvelopeService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CredentialEnvelopeService create(Ref ref) {
    return credentialEnvelopeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CredentialEnvelopeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CredentialEnvelopeService>(value),
    );
  }
}

String _$credentialEnvelopeServiceHash() =>
    r'3a1f43985b87ab91c9ec5be8a31b7455204d36b4';
